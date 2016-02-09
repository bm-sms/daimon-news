# Usage
#
# bin/rails r scripts/sync_wp_posts.rb DATABASE_URL SITE_FQDN ASSET_DIR
#
# Example
#
# bin/rails r scripts/sync_wp_posts.rb mysql://id:pass@host/table example.com //xxxxx.cloudfront.net/press/wp-content/uploads
#
WP_DB_URI = URI(ARGV[0])
FQDN      = ARGV[1]
ASSET_DIR = ARGV[2]

load Rails.root.join('lib/wp_models.rb')

WpApplicationRecord.connect_to(WP_DB_URI)

site = Site.find_by!(fqdn: FQDN)

target = WpPost.where('post_status = "publish" OR post_status = "future"').order(:id)

latest_updated_at = site.posts.maximum(:original_updated_at)
if latest_updated_at
  target = target.where('post_modified_gmt > ?', latest_updated_at)
end

puts "target : #{target.count}"

target.find_each.with_index do |wp_post, i|
  puts i
  site.transaction do
    # Skip not categorized post
    next unless wp_post.category_taxonomy

    wp_term = wp_post.category_taxonomy.wp_term
    category = site.categories.find_or_create_by!(name: wp_term.name) do |c|
      c.description = wp_post.category_taxonomy.description
      c.slug        = wp_term.slug
      c.order       = (site.categories.maximum(:order) || 0) + 1
    end

    wp_post.convert_image_url do |url|
      image = site.images.create!(remote_image_url: url)
      image.image_url
    end

    post = site.posts.find_or_initialize_by(id: wp_post.id)

    post.assign_attributes(
      title:                wp_post.post_title,
      published_at:         wp_post.post_date_gmt,
      body:                 wp_post.markdown_body,
      category:             category,
      remote_thumbnail_url: wp_post.thumbnail_url(ASSET_DIR),
      original_updated_at:  wp_post.post_modified_gmt,
      original_html:        wp_post.post_content,
      updated_at:           wp_post.post_modified_gmt
    )

    post.validate_markdown!

    post.save!
  end
end
