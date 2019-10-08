class PhotoUploader < CarrierWave::Uploader::Base
include CarrierWave::MiniMagick

  storage :file
  process resize_to_limit: [640, nil]

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "photos/"
  end

  # def default_url
  #   "photo/#{Time.now.year}/#{@name}.#{file.extension.downcase}.jpg"
  # end
  #
  # version :large do
  #   resize_to_limit(480, 480)
  # end

def filename
    if super.present?
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(current_path)
      "#{Time.now.year}/#{@name}.#{file.extension.downcase}"
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
