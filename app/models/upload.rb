# == Schema Information
#
# Table name: uploads
#
#  id              :integer          not null, primary key
#  url             :string           not null
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  file_name       :string
#  file_size_bytes :integer
#  file_type       :string
#  storage_key     :string
#
# Indexes
#
#  index_uploads_on_storage_key  (storage_key)
#  index_uploads_on_user_id      (user_id)
#

class Upload < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :url

  # The upload processor class needs to be set in an initializer otherwise this
  # code will crash. The main reason behind this is to be able to configure
  # different uploaders without changing the code.
  class << self
    def enabled?
      !processor.nil?
    end

    def processor
      Rails.configuration.x.upload_processor_class
    end

    def create_with_file(file, user)
      new.create_with_file(file, user)
    end
  end

  def create_with_file(file, user)
    self.user = user
    self.file_name = file.original_filename
    self.file_size_bytes = file.size
    self.file_type = file.content_type
    processor = self.class.processor.new(file)
    self.url = processor.run
    self.storage_key = processor.storage_key if processor.respond_to?(:storage_key)

    self
  end

  # Where pages should link to this upload. S3 uploads go through the app,
  # which checks the user is signed in before redirecting to S3.
  def link_url
    if stored_in_s3? && persisted?
      Rails.application.routes.url_helpers.file_upload_path(self)
    else
      url
    end
  end

  def stored_in_s3?
    storage_key.present?
  end

  # Response overrides for the presigned URL: images display inline with
  # their type; anything else downloads, so an uploaded HTML or SVG file
  # never renders as a page.
  def presigned_response_options
    if image?
      { response_content_type: file_type }
    else
      { response_content_disposition: ActionDispatch::Http::ContentDisposition
          .format(disposition: "attachment", filename: file_name.to_s) }
    end
  end

  def image?
    %w[image/jpeg image/png image/jpg image/gif].include? file_type
  end

  def markdown_link
    "#{"!" if image?}[#{file_name}](#{link_url})"
  end
end

