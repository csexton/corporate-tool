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

    it "uploads to s3 service with a public-read ACL" do
      upload = Upload.create_with_file(tardis, rory)

      expect(upload.valid?).to be true
      expect(upload.url).to match(%r{\Ahttps://.*corp\.example\.com/.+\.png\z})
      put = client.api_requests.find { |r| r[:operation_name] == :put_object }
      expect(put[:params]).to include(bucket: "corp.example.com", acl: "public-read")
    end

    it "retries without an ACL when the bucket does not allow ACLs" do
      client.stub_responses(:put_object, [
        "AccessControlListNotSupported",
        {}
      ])

      upload = Upload.create_with_file(tardis, rory)

      expect(upload.valid?).to be true
      puts_made = client.api_requests.select { |r| r[:operation_name] == :put_object }
      expect(puts_made.size).to eq 2
      expect(puts_made.last[:params]).not_to have_key(:acl)
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
