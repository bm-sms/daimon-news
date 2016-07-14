class Participant < ActiveRecord::Base
  has_many :credits, dependent: :destroy
  has_many :posts, through: :credits

  belongs_to :site

  validates :name, presence: true

  mount_uploader :photo, ImageUploader
end
