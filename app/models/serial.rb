class Serial < ActiveRecord::Base
  belongs_to :site
  has_many :posts, dependent: :nullify
  validates :thumbnail, presence: true

  mount_uploader :thumbnail, ImageUploader
end
