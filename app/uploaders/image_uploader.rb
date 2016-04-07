class ImageUploader < CarrierWave::Uploader::Base
  def store_dir
    [store_root_dir, "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"].compact.join("/")
  end

  private

  def store_root_dir
    ENV["HEROKU_APP_NAME"] if ENV["USE_SHARED_S3_BUCKET"]
  end
end
