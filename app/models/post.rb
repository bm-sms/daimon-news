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

  def markdown_from_original_html
    original_html.split(Page::SEPARATOR).map {|page|
      PandocRuby.convert(page, from: :html, to: 'markdown_github')
    }.join(Page::SEPARATOR + "\n")
  end

  def current_html
    markdown_from_original_html.split(Page::SEPARATOR).map {|page|
      # PandocRuby.convert(page, from: 'markdown_github-autolink_bare_uris', to: 'html')

      renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true), tables: true)
      renderer.render(page)
    }.join(Page::SEPARATOR + "\n")
  end

  def validate_markdown!
    # NOTE `autolink_bare_uris` option is only used to compare HTML structure. It should be removed later.

    original_doc = Nokogiri::HTML(_normalize_html(original_html))
    current_doc = Nokogiri::HTML(_normalize_html(current_html))

    _normalize_wrapped_paragraph(original_doc)
    _normalize_wrapped_paragraph(current_doc)

    _notmalize_text_content(original_doc)
    _notmalize_text_content(current_doc)

    diff = []

    original_doc.diff(current_doc) do |change, node|
      next if change == ' '
      next if node.text.blank?
      next if node.is_a?(Nokogiri::XML::Attr)

      diff << "#{change} #{node.to_html}"
    end

    # TODO If doc has some diff, the error should be raised.
    unless diff.empty?
      puts "Post#id: #{id}"
      puts diff.join("\n")
      puts
    end
  end

  private

  def _normalize_html(html)
    # XXX Workaround to suppress unexpected diff
    html
      .gsub(/ +/, ' ')
      .gsub(/\r\n/, "\n")
      .gsub(/\n+/, "")
  end

  def _normalize_wrapped_paragraph(doc)
    doc.search('p').each do |node|
      node.replace(node.inner_html) # Strip `<p>`
    end
  end

  def _notmalize_text_content(doc)
    # XXX Workaround to suppress unexpected diff
    doc.search('text()').each do |node|
      node.replace(node.text.strip.gsub(' ', ''))
    end
  end

  def around_posts_candidates
    site.posts.published.order_by_recently
  end
end
