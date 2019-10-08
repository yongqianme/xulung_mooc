# encoding: utf-8
class StillUploader < CarrierWave::Uploader::Base

include CarrierWave::Video  # for your video processing
include CarrierWave::Video::Thumbnailer
include CarrierWave::MiniMagick
include CarrierWave::MimeTypes

process :set_content_type

# IMAGE_EXTENSIONS = %w(jpg jpeg gif png)
# DOCUMENT_EXTENSIONS = %w(exe pdf doc docm xls)
# VIDEO_EXTENSIONS = %w(mp4 flv avi)
 version :thumb, :if => :thumbable? do
   process :efficient_conversion => [640, 960], :if => :pdf?
   process thumbnail: [{format: 'png', quality: 7, size:112, strip: false, square:false, logger: Rails.logger}], :if => :video?
      def full_filename for_file
        png_name for_file, version_name
      end
 end

 version :large, :if => :thumbable? do
   process :efficient_conversion => [640, 960], :if => :pdf?
   process thumbnail: [{format: 'png', quality: 7, size:800, strip: false, square:false, logger: Rails.logger}], :if => :video?
   def full_filename for_file
     png_name for_file, version_name
   end
 end

 def thumbable?(file)
   pdf?(file) || video?(file)
 end
def efficient_conversion(width, height)
    manipulate! do |img|
      img.format("png") do |c|
        c.fuzz        "3%"
        c.trim
        c.resize      "#{width}x#{height}>"
        c.resize      "#{width}x#{height}<"
      end
      img
    end
  end


  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end

  storage :file
  # storage :qiniu
  # self.qiniu_protocal = 'http'
#   self.qiniu_can_overwrite = true


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(mp4 flv avi pdf)
  end

  protected
    def video?(new_file)
      new_file.content_type.end_with? '/mp4'
    end

    def pdf?(new_file)
      new_file.content_type.end_with? '/pdf'
    end

    def not_image?(new_file)
      !new_file.content_type.start_with? 'image'
    end

end
