class ImagesController < ApplicationController
  def index
    if params[:path]
      aws_load(params[:path])
      render plain: @lists.inspect
    else
      @lists = []
      render plain: params.inspect
    end
  end

  private
    def aws_load(path)
      @s3 = Aws::S3::Resource.new
      @acbw_bucket = @s3.bucket(ENV['AWS_S3_BUCKET'])
      @lists = @acbw_bucket.objects(prefix: path).collect(&:key)
    end
end
