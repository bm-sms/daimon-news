class Post < ActiveRecord::Base
  belongs_to :site
  belongs_to :category
  belongs_to :author

  scope :published, -> { where('published_at <= ?', Time.current) }
  scope :order_by_recently, -> { order(:published_at => :desc, :id => :asc) }

  paginates_per 20

  mount_uploader :thumbnail, ImageUploader

  def pages
    @pages ||= Page.pages_for(body)
  end

  def related_posts
    maximum_id = Post.published.maximum(:id)

    Post.published.where(category: category).order("(id - #{id} + #{maximum_id} - 1) % #{maximum_id}").limit(9) # XXX 同じカテゴリの中から適当に返している
  end

  def next_post
    @next_post ||= around_posts_candidates
      .order(:id => :desc)
      .where('id > ?', id)
      .first
  end

  def previous_post
    @previous_post ||= around_posts_candidates
      .order(:id)
      .where('id < ?', id)
      .first
  end

  MD = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true), tables: true)

  def previous_html
    body.to_s.split(Page::SEPARATOR).map {|page| MD.render(page) }.join(Page::SEPARATOR)
  end

  def current_body
    Kramdown::Document.new(previous_html, input: 'html', hard_wrap: true).to_kramdown
  end

  def current_html
    current_body.split(Page::SEPARATOR).map {|page|
      Kramdown::Document.new(page, input: 'GFM', syntax_highlighter: 'rouge', hard_wrap: true).to_html
    }.join(Page::SEPARATOR)
  end

  private

  def around_posts_candidates
    site.posts.published.order_by_recently
  end
end
