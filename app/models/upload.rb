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
#  unique_id       :string
#  file_size_bytes :integer
#  file_type       :string
#
# Indexes
#
#  index_uploads_on_user_id  (user_id)
#

class Upload < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :url

  # The upload processor class needs to be set in an initializer otherwise this
  # code will crash. The main reason behind this is to be able to configure
  # different uploaders without changing the code.
  class << self
    def enabled?
      processor.respond_to?(:enabled?) && processor.enabled?
    end

    def processor
      Rails.configuration.x.upload_processor_class
    end

    def create_with_file(file, user)
      self.new.create_with_file(file, user)
    end
  end

  def create_with_file(file, user)
    self.user = user
    self.file_name = file.original_filename
    self.file_size_bytes = file.size
    self.file_type = file.content_type
    self.url = self.class.processor.new(file).run

    self
  end
end

