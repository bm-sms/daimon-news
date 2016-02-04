def render_md(text)
  Kramdown::Document.new(text.to_s, input: 'GFM', syntax_highlighter: 'rouge', hard_wrap: true).to_html
end

Post.all.each.with_index(1) {|post, index|
  p "#{index}: #{post.id}"

  md = Kramdown::Document.new(post.original_html, input: 'html', hard_wrap: true).to_kramdown

  previous_html = post.original_html
  current_html = render_md(md)

  previous_doc = Nokogiri::HTML(previous_html)
  current_doc  = Nokogiri::HTML(current_html)

  [previous_doc, current_doc].each do |doc|
    doc.search('*').each do |node|
      node.content = node.content.gsub(/[ \n]/, '')
    end
  end

  previous_doc.diff(current_doc) do |change, node|
    next if change == ' '
    next if node.text.blank?
    next if node.is_a?(Nokogiri::XML::Attr)

    puts change
    p node
    # puts "#{change} #{node.to_html}".ljust(30) + node.parent.path
  end
}
