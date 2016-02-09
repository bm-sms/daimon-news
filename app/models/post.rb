class Post < ActiveRecord::Base
  belongs_to :site
  belongs_to :category
  belongs_to :author

  validates :body, presence: true

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

  def validate_markdown!
    # XXX Dup with `ApplicationHelper#render_markdown`.

    # ReverseMarkdown.convert(original_html).gsub("\r", "\n")
    markdown = ReverseMarkdown.convert(_normalize_text(original_html), unknown_tags: :raise, github_flavored: true)
    pages = Page.pages_for(markdown)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: false), tables: true)

    current_html = renderer.render(pages.map(&:body).join)

    # TODO Compare `html` with `original_html`.
    original_doc = Nokogiri::HTML(_normalize_html(original_html))
    current_doc = Nokogiri::HTML(_normalize_html(current_html))

    current_doc.search('p').each do |node|
      node.replace(node.inner_html.gsub(/ /, '')) # Strip `<p>`
    end

    # TODO If doc has some diff, the error should be raised.

    original_doc.diff(current_doc) do |change, node|
      next if change == ' '
      next if node.text.blank?
      next if node.is_a?(Nokogiri::XML::Attr)

      puts change
      p node.to_html
    end
  end

  def _normalize_text(text)
    text.gsub("\r\n", "\n")
  end

  def _normalize_html(html)
    # XXX Workaround to suppress unexpected diff
    html
      .gsub(/ +/, ' ')
      .gsub(/\r\n/, "\n")
      .gsub(/\n+/, "")
  end

  private

  def around_posts_candidates
    site.posts.published.order_by_recently
  end
end
