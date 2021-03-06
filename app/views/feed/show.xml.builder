xml.instruct! :xml, version: '1.0'
xml.rss('version' => '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/') do
  xml.channel do
    xml.title current_site.name
    xml.description current_site.tagline
    xml.link root_url

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description <<-HTML
          #{image_tag(post.thumbnail_url)}
          #{content_tag("p", post.short_text_body)}
        HTML
        xml.category post.main_category.name
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.guid post_url(public_id: post.public_id), isPermaLink: true
        xml.link post_url(public_id: post.public_id)
      end
    end
  end
end
