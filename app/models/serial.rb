class Serial < ActiveRecord::Base
  belongs_to :site
  has_many :posts, dependent: :nullify
  validates :thumbnail, presence: true

  scope :published, -> { joins(:posts).merge(Post.published).uniq }

  mount_uploader :thumbnail, ImageUploader
end
