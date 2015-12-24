class Post < ActiveRecord::Base
  belongs_to :site
  belongs_to :category

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :order_by_recently, -> { order(:published_at => :desc, :original_id => :asc) }

  paginates_per 20

  def pages
    @pages ||= Page.pages_for(body)
  end

  def related_posts
    maximum_id = Post.published.maximum(:id)

    Post.published.where(category: category).order("(id - #{id} + #{maximum_id} - 1) % #{maximum_id}").limit(9) # XXX 同じカテゴリの中から適当に返している
  end

  def next_post
    @next_post ||= around_posts_candidates
      .order(:original_id => :desc)
      .where('original_id > ?', original_id)
      .first
  end

  def previous_post
    @previous_post ||= around_posts_candidates
      .order(:original_id)
      .where('original_id < ?', original_id)
      .first
  end

  private

  def around_posts_candidates
    site.posts.published.order_by_recently
  end
end
