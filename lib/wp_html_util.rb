require "daimon/render/html"

module WpHTMLUtil
  def normalize_html(html)
    # XXX Workaround to suppress unexpected diff
    html
      .gsub(/ +/, ' ')
      .gsub(/\r\n/, "\n")
      .gsub(/\n+/, "")
  end

  def strip_unnecessary_tag(doc)
    doc.search('div[dir="ltr"]').each do |node|
      node.replace(node.text)
    end
  end

  def convert_u_to_strong(doc)
    doc.search('u').each do |node|
      node.name = 'strong'
    end
  end

  def strip_img_attribtues(doc)
    doc.search('img').each do |node|
      white_list_attributes = %w(src title)
      (node.attributes.keys - white_list_attributes).each do |attr|
        node.remove_attribute(attr)
      end
    end
  end

  def normalize_wrapped_paragraph(doc)
    doc.search('p').each do |node|
      node.replace(node.inner_html) # Strip `<p>`
    end
  end

  def notmalize_text_content(doc)
    # XXX Workaround to suppress unexpected diff
    doc.search('text()').each do |node|
      node.replace(node.text.strip.gsub(' ', ''))
    end
  end

  def convert_image_url(doc)
    return "" unless block_given?

    links = {}

    doc.search('img').each do |element|
      original_src = element['src']
      new_src = yield(original_src)
      links[original_src] = new_src
      element['src'] = new_src
    end

    links.each do |original_src, new_src|
      doc.search("a[href='#{original_src}']").each do |element|
        element['href'] = new_src
      end
    end
  end

  def markdown_body(original_html, &block)
    return @markdown_body if @markdown_body

    html = Nokogiri::HTML(original_html).tap {|doc|
      convert_image_url(doc, &block)
      convert_u_to_strong(doc)
    }.search('body')[0].inner_html

    @markdown_body = html.split(Page::SEPARATOR).map {|page|
      PandocRuby.convert(page,
                         {
                           from: :html,
                           to: 'markdown_github'
                         },
                         "atx-header")
    }.join(Page::SEPARATOR + "\n")
    # XXX Workaround for compatibility
    # <strong><br/></strong> -(pandoc)-> "****" -(here)-> "<br>"
    # "****" is converted to <hr />(pandoc) or <hr>(redcarpet)
    @markdown_body = @markdown_body.gsub('****', '<br>')
  end

  def target_html
    markdown_body.split(Page::SEPARATOR).map {|page|
      # PandocRuby.convert(page, from: 'markdown_github-autolink_bare_uris', to: 'html')

      renderer = Redcarpet::Markdown.new(Daimon::Render::HTML.new(hard_wrap: true), tables: true)
      renderer.render(page)
    }.join(Page::SEPARATOR + "\n")
  end
end
