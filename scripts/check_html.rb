has_diff_count = 0

Post.all.each.with_index(1) {|post, index|
  p "#{index}: #{post.id}"

  previous_doc = Nokogiri::HTML(post.previous_html)
  current_doc  = Nokogiri::HTML(post.current_html)

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
