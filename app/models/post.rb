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
    markdown = original_html.split(Page::SEPARATOR).map {|page|
      PandocRuby.convert(page, from: :html, to: :markdown_github)
    }.join(Page::SEPARATOR + "\n")

    current_html = markdown.split(Page::SEPARATOR).map {|page|
      PandocRuby.convert(page, from: :markdown_github, to: :html)
    }.join(Page::SEPARATOR)

    # TODO Compare `html` with `original_html`.
    original_doc = Nokogiri::HTML(_normalize_html(original_html))
    current_doc = Nokogiri::HTML(_normalize_html(current_html))

    current_doc.search('p').each do |node|
      node.replace(node.inner_html) # Strip `<p>`
    end

    # Strip whitespace in text node
    current_doc.search('body').children.each do |node|
      node.replace(node.text.strip.gsub(/ +/, '')) if node.text?
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
