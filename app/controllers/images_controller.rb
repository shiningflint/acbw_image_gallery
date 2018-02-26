class ImagesController < ApplicationController
  def index
    if params[:path]
      aws_load(params[:path])
      # render plain: @lists.inspect
      print_regex(@lists, /uploads\/([0-9]+)\/([0-9]+)\/(.+\.jpg)/)
      render json: @lists
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

    def print_regex(list, pattern)
      list.each do |item|
        pattern.match(item)
        if pattern.match(item) != nil
          puts "#{pattern.match(item)[1]}, #{pattern.match(item)[2]}, #{pattern.match(item)[3]}"
        end
      end
    end
end
