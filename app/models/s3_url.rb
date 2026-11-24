# Pulls the bucket and object key out of an S3 object URL, in either the
# path style (https://s3.amazonaws.com/bucket/key) that Aws::S3::Object#public_url
# returns for dotted bucket names, or the virtual-hosted style
# (https://bucket.s3.amazonaws.com/key).
module S3Url
  PATTERN = %r{\Ahttps?://(?:(?<host_bucket>[^/]+)\.)?s3(?:[.-][a-z0-9-]+)*\.amazonaws\.com/(?<path>[^?#]+)\z}

  # Returns [bucket, key], or nil if the URL isn't an S3 object URL.
  def self.parse(url)
    match = PATTERN.match(url.to_s)
    return unless match

    path = URI::DEFAULT_PARSER.unescape(match[:path])
    if match[:host_bucket]
      [match[:host_bucket], path]
    else
      bucket, key = path.split("/", 2)
      [bucket, key] if key.present?
    end
  end
end
