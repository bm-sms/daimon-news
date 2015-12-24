class Post < ActiveRecord::Base
  belongs_to :site
  belongs_to :category

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :order_by_recently, -> { order(:published_at => :desc) }

  paginates_per 20

  def pages
    @pages ||= Page.pages_for(body)
  end

  def related_posts
    Post.limit(9) # XXX 同じカテゴリの中から適当に返す
  end
end
