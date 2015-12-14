class ImageUploader < CarrierWave::Uploader::Base
  if fog_credentials.present?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
