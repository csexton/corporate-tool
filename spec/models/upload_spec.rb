require 'rails_helper'

RSpec.describe Upload, type: :model do
  include ActionDispatch::TestProcess
  let(:rory) { User.create!(name: 'Rory', uid: "1")}
  let(:tardis) { fixture_file_upload("spec/fixtures/tardis.png", "image/png") }


  describe "S3 Uploads" do


    before do
      allow(Rails.configuration.x)
        .to receive(:upload_processor_class)
        .and_return(UploadProcessors::S3)
    end

    let(:client) do
      Aws::S3::Client.new(stub_responses: true, region: "us-east-1",
                          credentials: Aws::Credentials.new("id", "secret"))
    end

    around do |example|
      bucket = ENV["S3_BUCKET"]
      ENV["S3_BUCKET"] = "corp.example.com"
      example.run
    ensure
      ENV["S3_BUCKET"] = bucket
    end

    before do
      allow(Aws::S3::Client).to receive(:new).and_return(client)
    end

    it "uploads to a private s3 object and keeps the key" do
      upload = Upload.create_with_file(tardis, rory)

      expect(upload.valid?).to be true
      expect(upload.storage_key).to match(/\A[0-9a-f-]{36}\.png\z/)
      expect(upload.url).to end_with("corp.example.com/#{upload.storage_key}")
      put = client.api_requests.find { |r| r[:operation_name] == :put_object }
      expect(put[:params]).to include(bucket: "corp.example.com", key: upload.storage_key,
                                      content_type: "image/png")
      expect(put[:params]).not_to have_key(:acl)
    end

    it "links pages to the app instead of S3 once saved" do
      upload = Upload.create_with_file(tardis, rory)
      upload.save!

      expect(upload.markdown_link).to eq "![tardis.png](/uploads/#{upload.id}/file)"
    end

    it "shows images inline and downloads everything else" do
      image = Upload.new(file_type: "image/png", file_name: "a.png")
      other = Upload.new(file_type: "text/html", file_name: "a.html")

      expect(image.presigned_response_options).to eq(response_content_type: "image/png")
      expect(other.presigned_response_options[:response_content_disposition]).to start_with("attachment")
    end
  end

  describe "Filesystem Uploads" do
    before do
      allow(Rails.configuration.x)
        .to receive(:upload_processor_class)
        .and_return(UploadProcessors::Filesystem)
    end

    it "uploads to filesystem" do
      uploader = UploadProcessors::Filesystem.new(tardis)
      upload = Upload.create_with_file(tardis, rory)
      expect(upload.valid?).to be true
      expect(upload.url).to match(/\/uploads\/.*\.png/)
    end
  end

  it "puts a bang on an image markdown link" do
    upload = Upload.new url: "https://example.com/image.png",
                        file_name: "png",
                        file_type: "image/png"

    expect(upload.markdown_link).to eq "![png](https://example.com/image.png)"
  end

  it "formats a markdown link" do
    upload = Upload.new url: "https://example.com/file.zip",
                        file_name: "zip",
                        file_type: "application/zip"

    expect(upload.markdown_link).to eq "[zip](https://example.com/file.zip)"
  end
end
