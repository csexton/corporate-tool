Rails.application.config.before_initialize do
  klass = case (ENV['UPLOAD_PROCESSOR'] || "filesystem").to_sym
          when :filesystem
            UploadProcessors::Filesystem
          when :s3
            UploadProcessors::S3
          else
            UploadProcessors::Null
          end
  #klass = UploadProcessors.const_get(ENV.fetch('UPLOAD_PROCESSOR').classify
  Rails.configuration.x.upload_processor_class = klass
end
