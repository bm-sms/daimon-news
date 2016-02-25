class Participant < ActiveRecord::Base
  has_many :credits, dependent: :destroy

  belongs_to :site

  validates :name, presence: true

  mount_uploader :photo, ImageUploader
end
