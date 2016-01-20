class Site < ActiveRecord::Base
  has_many :categories, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :fixed_pages, dependent: :destroy
  has_many :links, dependent: :destroy

  validates :name, presence: true
  validates :fqdn, presence: true, uniqueness: true

  mount_uploader :logo_image, ImageUploader
  mount_uploader :favicon_image, ImageUploader
  mount_uploader :mobile_favicon_image, ImageUploader
end
