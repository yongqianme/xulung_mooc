class AvatarUploader < CarrierWave::Uploader::Base
include CarrierWave::MiniMagick

  storage :file
  process resize_to_limit: [100, 100]

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "avatar/"
  end
  # version :large do
  #   resize_to_fill(200, 200)
  # end
  # version :medum do
  #   resize_to_fill(100, 100)
  # end
  #
  # version :small do
  #   resize_to_fill(50, 50)
  # end

def filename
    if super.present?
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(current_path)
      "#{Time.now.year}/#{@name}.#{file.extension.downcase}"
    end
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end
