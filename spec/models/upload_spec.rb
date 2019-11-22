require 'rails_helper'

RSpec.describe Upload, type: :model do
  include ActionDispatch::TestProcess
  let(:rory) { User.create!(name: 'Rory', uid: "1")}
  let(:tardis) { fixture_file_upload("spec/fixtures/tardis.png") }


  describe "S3 Uploads" do


    before do
      allow(Rails.configuration.x)
        .to receive(:upload_processor_class)
        .and_return(UploadProcessors::S3)
    end

    it "uploads to s3 service" do
      uploader = UploadProcessors::S3.new(tardis)

      # Stub all the things for the AWS SDK API:
      url = "https://s3.amazonaws.com/corp.radiusnetworks.com/1.png"
      object_double = double("AWS S3 Object", upload_file: nil, public_url: url)
      bucket_double = double("AWS S3 Bucket", object: object_double)
      resource_double = double(Aws::S3::Resource, bucket: bucket_double)

      allow(Aws::S3::Resource).to receive(:new)
        .and_return(resource_double)

      upload = Upload.create_with_file(tardis, rory)
      expect(upload.valid?).to be true
      expect(upload.url).to eq url

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
