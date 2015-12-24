xml.instruct! :xml, version: '1.0'
xml.rss('version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/') do
  xml.channel do
    xml.title current_site.name
    xml.link root_url

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.body
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.guid post.id
        xml.link post_url(post)
      end
    end
  end
end
