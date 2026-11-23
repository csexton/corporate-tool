require 'aws-sdk-s3'

class UploadProcessors::S3
  attr_reader :file
  def initialize(file, client: Aws::S3::Client.new)
    @file = file
    @client = client
  end

  def run
    # This code expects the following enviroment variables to be set:
    #   - AWS_REGION
    #   - AWS_ACCESS_KEY_ID
    #   - AWS_SECRET_ACCESS_KEY
    #   - S3_BUCKET
    #
    bucket = ENV['S3_BUCKET']
    key = unique_filename

    begin
      upload(bucket, key, acl: 'public-read')
    rescue Aws::S3::Errors::AccessControlListNotSupported
      # Buckets with Object Ownership set to "Bucket owner enforced" (the
      # default for new buckets) reject ACLs; public read must come from a
      # bucket policy instead.
      upload(bucket, key)
    end

    Aws::S3::Object.new(bucket_name: bucket, key: key, client: @client).public_url
  end

  private

  def upload(bucket, key, **options)
    Aws::S3::TransferManager.new(client: @client)
      .upload_file(file.path, bucket: bucket, key: key, **options)
  end

  def unique_filename
    "#{SecureRandom.uuid}#{File.extname(file.original_filename)}"
  end

end
