class ImageUploader < ApplicationUploader
  include CarrierWave::MiniMagick

  version :resized, if: :resizable?

  version :resized do
    process resize_to_fill: [100, 100]
  end

  private

  def resizable? picture
    !picture.content_type.blank?
  end
end
