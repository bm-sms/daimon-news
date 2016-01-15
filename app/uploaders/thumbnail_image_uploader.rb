# encoding: utf-8

class ThumbnailImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if fog_credentials.present?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [50, 50]
  end
end
