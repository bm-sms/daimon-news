# Usage
#
# bin/rails r scripts/sync_wp_posts.rb DATABASE_URL SITE_FQDN ASSET_DIR
#
# Example
#
# bin/rails r scripts/immport_wp_thumbnail.rb mysql://id:pass@host/table example.com //xxxxx.cloudfront.net/press/wp-content/uploads
#
WP_DB_URI = URI(ARGV[0])
FQDN      = ARGV[1]
ASSET_DIR = ARGV[2]

load Rails.root.join('lib/wp_models.rb')

WpApplicationRecord.connect_to(WP_DB_URI)

site = Site.find_by!(fqdn: FQDN)

site.posts.find_each do |post|
  wp_post = WpPost.find(post.public_id)
  post.update!(remote_thumbnail_url: wp_post.thumbnail_url(ASSET_DIR))
end
