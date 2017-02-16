class ImageUploader < ApplicationUploader
  include CarrierWave::ImageOptimizer
  process :optimize
end
