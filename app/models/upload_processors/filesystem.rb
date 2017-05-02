class UploadProcessors::Filesystem
  attr_reader :file
  def initialize(file)
    @file = file
  end

  def run
    FileUtils.mkdir_p filesystem_path
    FileUtils.move file.path, filesystem_path.join(unique_filename).to_s
    Rails.logger.info("Process upload for #{file}")
    url_path
  end

  private

  def url_path
    "/uploads/#{unique_filename}"
  end

  def filesystem_path
    Rails.root.join('public', 'uploads')
  end

  def unique_filename
    @unique_filename ||= "#{SecureRandom.uuid}#{File.extname(file.original_filename)}"
  end
end
