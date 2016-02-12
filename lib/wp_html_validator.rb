require "pandoc-ruby"
require "nokogiri"

class WpHTMLValidator

  class Error < StandardError
  end

  attr_reader :id, :original_html

  def initialize(id, original_html)
    @id = id
    @original_html = original_html
    @markdown_text = nil
  end

  def validate
    # NOTE `autolink_bare_uris` option is only used to compare HTML structure. It should be removed later.

    original_doc = Nokogiri::HTML(_normalize_html(original_html))
    current_doc = Nokogiri::HTML(_normalize_html(current_html))

    _convert_u_to_strong(original_doc)
    _strip_unnecessary_tag(original_doc)

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

    unless diff.empty?
      puts "Post#id: #{id}"
      puts diff.join("\n")
      puts
    end

    diff.empty?
  end

  def validate!
    unless validate
      raise Error, "#{id} has some difference."
    end
  end

  def markdown_text
    return @markdown_text if @markdown_text

    html = Nokogiri::HTML(original_html).tap {|doc|
      _convert_u_to_strong(doc)
      _strip_img_attribtues(doc)
    }.search('body')[0].inner_html

    html.split(Page::SEPARATOR).map {|page|
      PandocRuby.convert(page, from: :html, to: 'markdown_github')
    }.join(Page::SEPARATOR + "\n")
      .gsub('****', '<br>') # XXX Workaround for compatibility
  end

  def current_html
    markdown_text.split(Page::SEPARATOR).map {|page|
      # PandocRuby.convert(page, from: 'markdown_github-autolink_bare_uris', to: 'html')

      renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true), tables: true)
      renderer.render(page)
    }.join(Page::SEPARATOR + "\n")
  end

  private

  def _normalize_html(html)
    # XXX Workaround to suppress unexpected diff
    html
      .gsub(/ +/, ' ')
      .gsub(/\r\n/, "\n")
      .gsub(/\n+/, "")
  end

  def _strip_unnecessary_tag(doc)
    doc.search('div[dir="ltr"]').each do |node|
      node.replace(node.text)
    end
  end

  def _convert_u_to_strong(doc)
    doc.search('u').each do |node|
      node.name = 'strong'
    end
  end

  def _strip_img_attribtues(doc)
    doc.search('img').each do |node|
      white_list_attributes = %w(src title)
      (node.attributes.keys - white_list_attributes).each do |attr|
        node.remove_attribute(attr)
      end
    end
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
end
