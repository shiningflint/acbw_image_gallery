class ImagesController < ApplicationController

  def index
    @lists = aws_load('uploads')
    @images = print_regex(@lists, /uploads\/([0-9]+)\/([0-9]+)\/(.+\.jpg)/)
    render json: @images
  end

  private
    def aws_load(path)
      s3 = Aws::S3::Resource.new
      acbw_bucket = s3.bucket(ENV['AWS_S3_BUCKET'])
      return acbw_bucket.objects(prefix: path).collect(&:key)
    end

    def print_regex(list, pattern)
      images = Hash.new

      list.each do |item|
        pattern.match(item)
        if pattern.match(item) != nil
          images[pattern.match(item)[1]] = { pattern.match(item)[2] => [] } if images[pattern.match(item)[1]].nil?
          images[pattern.match(item)[1]][pattern.match(item)[2]] = [] if images[pattern.match(item)[1]][pattern.match(item)[2]].nil?
          images[pattern.match(item)[1]][pattern.match(item)[2]] << pattern.match(item)[3]
        end
      end

      images
    end
end
