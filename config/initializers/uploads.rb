Rails.application.config.before_initialize do
  if Rails.env.test?
    Rails.configuration.x.upload_processor_class = UploadProcessors::Null
  else
    klass = case (ENV['UPLOAD_PROCESSOR'] || "filesystem").to_sym
            when :filesystem
              UploadProcessors::Filesystem
            when :s3
              UploadProcessors::S3
            else
              nil
            end
    #klass = UploadProcessors.const_get(ENV.fetch('UPLOAD_PROCESSOR').classify
    Rails.configuration.x.upload_processor_class = klass
  end
end
