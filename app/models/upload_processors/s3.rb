require 'aws-sdk'

class UploadProcessors::S3
  attr_reader :file
  def initialize(file)
    @file = file
  end

  def run
    # This code expects the following enviroment variables to be set:
    #   - AWS_REGION
    #   - AWS_ACCESS_KEY_ID
    #   - AWS_SECRET_ACCESS_KEY
    #   - S3_BUCKET
    #
    s3 = Aws::S3::Resource.new
    key = unique_filename
    obj = s3.bucket(ENV['S3_BUCKET']).object(key)
    obj.upload_file file.path, {acl: 'public-read'}

    obj.public_url
  end

  private

  def unique_filename
    "#{SecureRandom.uuid}#{File.extname(file.original_filename)}"
  end

end
