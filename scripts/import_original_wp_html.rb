# Usage
#
# bin/rails r scripts/import_original_wp_html.rb DATABASE_URL SITE_FQDN
#
# Example
#
# bin/rails r scripts/import_original_wp_html.rb mysql://id:pass@host/table example.com
#
WP_DB_URI = URI(ARGV[0])
FQDN      = ARGV[1]

load Rails.root.join('lib/wp_models.rb')

WpApplicationRecord.connect_to(WP_DB_URI)

site = Site.find_by!(fqdn: FQDN)

puts "target : #{site.posts.count}"

site.posts.find_each.with_index do |post, i|
  puts i

  site.transaction do
    wp_post = WpPost.find_by(id: post.id)

    next unless wp_post

    post.update!(original_html: wp_post.post_content)
  end
end
