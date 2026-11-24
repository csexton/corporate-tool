# Uploads are moving from public S3 URLs to /uploads/:id/file, which
# redirects signed-in users to a short-lived presigned URL. That needs the
# S3 object key, so store it and backfill it from the existing public URLs.
class AddStorageKeyToUploads < ActiveRecord::Migration[8.1]
  class MigrationUpload < ActiveRecord::Base
    self.table_name = "uploads"
  end

  # Path style: https://s3.amazonaws.com/bucket/key
  # Virtual-hosted style: https://bucket.s3.amazonaws.com/key
  S3_URL = %r{\Ahttps?://(?:(?<host_bucket>[^/]+)\.)?s3(?:[.-][a-z0-9-]+)*\.amazonaws\.com/(?<path>[^?#]+)\z}

  def up
    add_column :uploads, :storage_key, :string
    add_index :uploads, :storage_key

    MigrationUpload.reset_column_information
    MigrationUpload.where("url LIKE ?", "%amazonaws.com/%").find_each do |upload|
      match = S3_URL.match(upload.url)
      next unless match

      path = URI::DEFAULT_PARSER.unescape(match[:path])
      key = match[:host_bucket] ? path : path.split("/", 2)[1]
      upload.update_column(:storage_key, key) if key.present?
    end
  end

  def down
    remove_index :uploads, :storage_key
    remove_column :uploads, :storage_key
  end
end
