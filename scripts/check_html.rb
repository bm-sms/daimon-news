def render_md(text)
  Kramdown::Document.new(text.to_s, input: 'GFM', syntax_highlighter: 'rouge', hard_wrap: true).to_html
end

has_diff_count = 0

Post.all.each.with_index(1) {|post, index|
  p "#{index}: #{post.id}"

  md = Kramdown::Document.new(post.original_html, input: 'html', hard_wrap: true).to_kramdown

  previous_html = post.original_html
  current_html = md.split(Page::SEPARATOR).map {|page| render_md(page) }.join(Page::SEPARATOR)

  previous_doc = Nokogiri::HTML(previous_html)
  current_doc  = Nokogiri::HTML(current_html)

  [previous_doc, current_doc].each do |doc|
    doc.search('*').each do |node|
      node.content = node.content.gsub(/[ \n]/, '')
    end
  end

  has_diff = false

  previous_doc.diff(current_doc) do |change, node|
    next if change == ' '
    next if node.text.blank?
    next if node.is_a?(Nokogiri::XML::Attr)

    has_diff = true

    puts change
    p node.to_html
    # puts "#{change} #{node.to_html}".ljust(30) + node.parent.path
  end

  has_diff_count += 1 if has_diff
}

puts "* #{has_diff_count}/#{Post.count} posts has diff."
