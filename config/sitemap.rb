site = Site.first # TODO Detect site in some way

SitemapGenerator::Sitemap.default_host = "https://#{site.fqdn}"
SitemapGenerator::Sitemap.create do
  site.posts.find_each do |post|
    add post_path(post), changefreq: 'weekly', priority: 0.8
  end

  site.categories do |category|
    add category_path(category), changefreq: 'daily', priority: 0.6
  end

  site.fixed_pages.find_each do |fixed_page|
    add fixed_page_path(fixed_page), changefreq: 'weekly', priority: 0.5
  end
end
