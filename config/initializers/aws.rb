Aws.config.update({
  region: ENV['AWS_S3_REGION'],
  credentials: Aws::Credentials.new(ENV['AWS_S3_ID'], ENV['AWS_S3_KEY'])
})

# uncomment below when testing with windows
# Aws.use_bundled_cert!
