site = Site.find(ENV['SITEMAP_SITE_ID'])

SitemapGenerator::Sitemap.default_host = "https://#{site.fqdn}"
SitemapGenerator::Sitemap.public_path = "tmp/sitemap/#{site.id}"

# XXX Prefer using `ENV` to `CarrierWave`?
carrierwave = CarrierWave::Uploader::Base
if carrierwave.fog_directory
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    fog_provider: 'AWS',
    aws_access_key_id: carrierwave.fog_credentials[:aws_access_key_id],
    aws_secret_access_key: carrierwave.fog_credentials[:aws_secret_access_key],
    fog_directory: carrierwave.fog_directory,
    fog_region: carrierwave.fog_credentials[:region]
  )

  SitemapGenerator::Sitemap.sitemaps_host = "https://#{carrierwave.fog_directory}.s3.amazonaws.com/"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{site.id}/"
end

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
