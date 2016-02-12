require "pandoc-ruby"
require "nokogiri"
require "wp_html_util"

class WpHTMLValidator
  include WpHTMLUtil

  class Error < StandardError
  end

  attr_reader :id, :original_html

  def initialize(id, original_html)
    @id = id
    @original_html = original_html
    @markdown_text = nil
  end

  def validate(display_error: false)
    # NOTE `autolink_bare_uris` option is only used to compare HTML structure. It should be removed later.

    original_doc = Nokogiri::HTML(normalize_html(original_html))
    current_doc = Nokogiri::HTML(normalize_html(current_html))

    convert_u_to_strong(original_doc)
    strip_unnecessary_tag(original_doc)

    normalize_wrapped_paragraph(original_doc)
    normalize_wrapped_paragraph(current_doc)

    notmalize_text_content(original_doc)
    notmalize_text_content(current_doc)

    diff = []

    original_doc.diff(current_doc) do |change, node|
      next if change == ' '
      next if node.text.blank?
      next if node.is_a?(Nokogiri::XML::Attr)

      diff << "#{change} #{node.to_html}"
    end

    unless diff.empty?
      if display_error
        $stderr.puts "Post#id: #{id}"
        $stderr.puts diff.join("\n")
        $stderr.puts
      end
    end

    diff.empty?
  end

  def validate!
    unless validate(display_error: true)
      raise Error, "#{id} has some difference."
    end
  end

  def markdown_body(&block)
    super(original_html, &block)
  end
end