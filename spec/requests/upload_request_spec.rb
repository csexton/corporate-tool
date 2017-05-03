require 'rails_helper'

RSpec.describe "Uploads", type: :request do
  let(:rory) { User.create!(name: 'Rory', uid: "1")}
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
      upload = Upload.create!(url: "http://example.com/image.png", user: rory)
      get upload_path(upload)
      expect(response.body).to include("example.com/image.png")
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

end
