xml.instruct! :xml, version: '1.0'
xml.rss('version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/') do
  xml.channel do
    xml.title current_site.name
    xml.description current_site.tagline
    xml.link root_url

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description render_markdown(post.body)
        xml.category post.category.name
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.guid post_url(post), isPermaLink: true
        xml.link post_url(post)
      end
    end
  end
end
