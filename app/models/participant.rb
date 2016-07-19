class Participant < ActiveRecord::Base
  has_many :credits, dependent: :destroy
  has_many :posts, through: :credits

  belongs_to :site

  validates :name, presence: true

  scope :published, -> { joins(:posts).merge(Post.published).uniq }
  scope :order_by_recent, -> { order(id: :desc) }

  mount_uploader :photo, ImageUploader
end
