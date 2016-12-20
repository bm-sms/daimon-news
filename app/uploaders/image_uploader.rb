class ImageUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  version :resized do
    process resize_to_fill: [100, 100]
  end
end
