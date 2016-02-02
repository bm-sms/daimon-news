class Author < ActiveRecord::Base
  belongs_to :site

  validates :name, presence: true
  validates :responsibility, presence: true

  mount_uploader :photo, ImageUploader
end
