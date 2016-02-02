class Image < ActiveRecord::Base
  belongs_to :site
  mount_uploader :image, ImageUploader
end
