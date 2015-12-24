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
    @next_post ||= Post.from(
      "(#{around_posts_candidates.select('posts.*, lag(id, 1, NULL) OVER(ORDER BY published_at DESC, original_id ASC) AS previous_post_id').to_sql}) AS posts"
    ).find_by(previous_post_id: id)
  end

  def previous_post
    @previous_post ||= Post.from(
      "(#{around_posts_candidates.select('posts.*, lead(id, 1, NULL) OVER(ORDER BY published_at DESC, original_id ASC) AS next_post_id').to_sql}) AS posts"
    ).find_by(next_post_id: id)
  end

  private

  def around_posts_candidates
    site.posts.published.order_by_recently.where(category: category)
  end
end
