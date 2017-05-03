class UploadProcessors::Test
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def run
    Rails.logger.error "No upload strategy configured, unable to process #{file}"
  end
end
