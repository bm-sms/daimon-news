class Participant < ActiveRecord::Base
  has_many :credits, dependent: :destroy
  has_many :posts, through: :credits

  belongs_to :site

  validates :name, presence: true

  scope :having_published_posts, -> { joins(:posts).merge(Post.published).uniq }
  scope :sorted, -> { order(:name) }

  mount_uploader :photo, ImageUploader
end
