class Author < ActiveRecord::Base
  belongs_to :site

  has_many :posts, dependent: :nullify

  validates :name, presence: true

  mount_uploader :photo, ImageUploader
end
