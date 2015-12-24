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
    maximum_id = Post.published.maximum(:id)

    Post.published.where(category: category).order("(id - #{id} + #{maximum_id} - 1) % #{maximum_id}").limit(9) # XXX 同じカテゴリの中から適当に返している
  end

  def next_post
    Post.published.where(Post.arel_table[:published_at].gt(published_at))
      .order(published_at: :asc).limit(1)
  end

  def previous_post
    Post.published.where(Post.arel_table[:published_at].lt(published_at))
      .order(published_at: :desc).limit(1)
  end
end
