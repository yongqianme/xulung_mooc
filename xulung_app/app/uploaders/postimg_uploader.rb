# encoding: utf-8

class PostimgUploader < CarrierWave::Uploader::Base

include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :large do
    resize_to_limit(480, 480)
  end

  version :thumb do
    resize_to_fill(100, 100)
  end

  def extension_white_list
    %w(png jpg)
  end
end
