require 'aws-sdk-s3'

# Stores uploads as private S3 objects. They're served through
# /uploads/:id/file, which redirects signed-in users to a presigned URL.
#
# Expects these environment variables:
#   - AWS_REGION
#   - AWS_ACCESS_KEY_ID
#   - AWS_SECRET_ACCESS_KEY
#   - S3_BUCKET
class UploadProcessors::S3
  PRESIGNED_URL_TTL = 5.minutes

  attr_reader :file, :storage_key

  def self.bucket
    ENV['S3_BUCKET']
  end

  def self.presigned_url(key, client: Aws::S3::Client.new, **response_options)
    Aws::S3::Presigner.new(client: client).presigned_url(
      :get_object,
      bucket: bucket, key: key, expires_in: PRESIGNED_URL_TTL.to_i,
      **response_options
    )
  end

  def initialize(file, client: Aws::S3::Client.new)
    @file = file
    @client = client
  end

  def run
    @storage_key = unique_filename

    options = { bucket: self.class.bucket, key: storage_key }
    options[:content_type] = file.content_type if file.content_type.present?
    Aws::S3::TransferManager.new(client: @client).upload_file(file.path, **options)

    # Kept for reference; it only works while the bucket allows public reads.
    Aws::S3::Object.new(bucket_name: self.class.bucket, key: storage_key, client: @client).public_url
  end

  private

  def unique_filename
    "#{SecureRandom.uuid}#{File.extname(file.original_filename)}"
  end
end
