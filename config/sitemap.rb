site = Site.find(ENV['SITEMAP_SITE_ID'])

SitemapGenerator::Sitemap.default_host = "https://#{site.fqdn}"
SitemapGenerator::Sitemap.public_path = "tmp/sitemap/#{site.id}"

if ENV.has_key?('S3_BUCKET')
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    fog_provider: 'AWS',
    aws_access_key_id:     ENV['S3_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
    fog_directory:         ENV['S3_BUCKET'],
    fog_region:            ENV['S3_REGION']
  )

  SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{site.id}/"
end

SitemapGenerator::Sitemap.create do
  site.posts.published.find_each do |post|
    add post_path(post), changefreq: 'weekly', priority: 0.8
  end

  site.categories.find_each do |category|
    add category_path(category.slug), changefreq: 'daily', priority: 0.6
  end
end
