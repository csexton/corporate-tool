require 'rails_helper'

RSpec.describe "Uploads", type: :request do
  let(:rory) { User.create!(name: 'Rory Williams', uid: "1")}
  let(:tardis) { fixture_file_upload("spec/fixtures/tardis.png") }
  let(:sonic) { fixture_file_upload("spec/fixtures/sonic.png") }
  let(:valid_attributes) { { file: tardis } }

  describe "GET index" do
    it "redirects when unauthenticated" do
      get uploads_path
      expect(response.status).to be(302)
    end

    it "loads the index page" do
      sign_in rory
      get uploads_path
      expect(response.status).to be(200)
    end
  end

  describe "GET show" do
    it "includes the url type in the show page" do
      sign_in rory
      upload = Upload.create!(url: "http://example.com/tardis_blueprints.png", user: rory)
      get upload_path(upload)
      expect(response.body).to include("example.com/tardis_blueprints.png")
    end
  end

  describe "GET file" do
    let(:client) do
      Aws::S3::Client.new(stub_responses: true, region: "us-east-1",
                          credentials: Aws::Credentials.new("id", "secret"))
    end

    around do |example|
      bucket = ENV["S3_BUCKET"]
      ENV["S3_BUCKET"] = "black-archive.example.com"
      example.run
    ensure
      ENV["S3_BUCKET"] = bucket
    end

    before { allow(Aws::S3::Client).to receive(:new).and_return(client) }

    let(:upload) do
      Upload.create!(url: "https://s3.amazonaws.com/black-archive.example.com/sonic_screwdriver.png",
                     storage_key: "sonic_screwdriver.png", file_type: "image/png", user: rory)
    end

    it "requires signing in" do
      get file_upload_path(upload)

      expect(response).to redirect_to(welcome_auth_path(origin: file_upload_path(upload)))
    end

    it "redirects to a short-lived presigned S3 URL" do
      sign_in User.create!(name: "Amy Pond", uid: "2")

      get file_upload_path(upload)

      expect(response.status).to eq 302
      location = URI(response.location)
      expect(location.host).to include("amazonaws.com")
      expect(location.to_s).to include("sonic_screwdriver.png")
      params = Rack::Utils.parse_query(location.query)
      expect(params["X-Amz-Expires"]).to eq "300"
      expect(params["X-Amz-Signature"]).to be_present
      expect(params["response-content-type"]).to eq "image/png"
      expect(response.headers["Cache-Control"]).to include("private")
    end

    it "redirects to the stored URL for uploads not in S3" do
      sign_in rory
      local = Upload.create!(url: "/uploads/vortex_manipulator.png", user: rory)

      get file_upload_path(local)

      expect(response).to redirect_to("/uploads/vortex_manipulator.png")
    end
  end

  describe "GET new" do
    it "includes the title in the new page" do
      sign_in rory
      get new_upload_path
      expect(response.body).to include("New Upload")
    end
  end

  describe "POST create" do
    it "creates a file from the standard form params" do
      sign_in rory

      expect {
        post uploads_path, params: {upload: valid_attributes}
      }.to change(Upload, :count).by(1)
    end

    it "creates an upload when receiveing the params from InlineAttachment.js" do
      # This version of the post doesn't nest the params attrs under a `upload`
      # key at the top level.
      sign_in rory
      expect {
        post uploads_path, params: valid_attributes
      }.to change(Upload, :count).by(1)
    end
  end

  describe "POST iframe create" do
    it "renders the javascript callback into the page" do
      sign_in rory

      post uploads_path, params: {upload: valid_attributes, strategy: "iframe"}

      # This is a ejs-like callback that happens when the form posts to the
      # iframe directly. See uploads.coffee for details.
      expect(response.body).to include "parent.handle_iframe_upload("
    end

    it "runs the callback under the CSP nonce and escapes the file name" do
      sign_in rory
      evil = Rack::Test::UploadedFile.new(
        "spec/fixtures/tardis.png", "image/png",
        original_filename: "dalek');alert(1)//</script><script>alert(2).png"
      )

      post uploads_path, params: {upload: {file: evil}, strategy: "iframe"}

      nonce = response.headers["Content-Security-Policy"][/'nonce-([^']+)'/, 1]
      expect(nonce).to be_present
      expect(response.body).to include(%(nonce="#{nonce}"))
      expect(response.body).not_to include("</script><script>")
      expect(response.body).not_to include("dalek');alert(1)")
    end
  end

  describe "Content-Security-Policy" do
    it "only allows our own scripts" do
      sign_in rory

      get uploads_path

      csp = response.headers["Content-Security-Policy"]
      expect(csp).to match(/script-src 'self' 'nonce-[^']+'(;|$)/)
      expect(csp).not_to include("unsafe-eval")
      expect(csp).to include("object-src 'none'")
      expect(csp).to include("frame-ancestors 'self'")
    end
  end
end
