class Participant < ActiveRecord::Base
  has_many :credits, dependent: :destroy
  has_many :posts, through: :credits

  belongs_to :site

  validates :name, presence: true

  scope :having_published_posts, -> { joins(:posts).merge(Post.published).uniq }
  scope :sorted, -> { order(:name) }

  mount_uploader :photo, ImageUploader

  # TODO: Remove the following workaround after https://github.com/bm-sms/daimon-news/pull/565 deplyed.

  def description
    respond_to?(:summary) ? summary : super
  end

  def description=(description)
    if respond_to?(:summary=)
      self.summary = description
    else
      super
    end
  end
end
