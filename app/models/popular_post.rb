class PopularPost < ActiveRecord::Base
  belongs_to :site
  belongs_to :post

  scope :published, -> { joins(:post).merge(Post.published) }
  scope :ordered, -> { order(:rank) }
end
