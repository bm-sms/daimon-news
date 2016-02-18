# Usage
#
# bin/rails r scripts/import_original_wp_html.rb WP_BASE_URI SITE_FQDN
#
# Example
#
# bin/rails r scripts/import_original_wp_html.rb https://old-press.example.com/ new.example.com
#
require "open-uri"

WP_BASE_URI = URI(ARGV[0])
FQDN      = ARGV[1]

site = Site.find_by!(fqdn: FQDN)

puts "target : #{site.posts.count}"

site.posts.find_each.with_index do |post, i|
  puts i

  site.transaction do
    uri = WP_BASE_URI + "#{post.public_id}?all=true"
    html = open(uri).read

    post.update!(original_html: html)
  end
end
