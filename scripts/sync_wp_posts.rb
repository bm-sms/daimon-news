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

class WpApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

WpApplicationRecord.establish_connection(
  adapter:  'mysql2',
  host:     WP_DB_URI.host,
  username: WP_DB_URI.user,
  password: WP_DB_URI.password,
  database: WP_DB_URI.path[1..-1]
)

class WpPost < WpApplicationRecord
  has_many :wp_term_relationships, foreign_key: :object_id
  has_many :wp_term_taxonomies, through: :wp_term_relationships

  has_many :wp_postmeta, foreign_key: :post_id

  def category_taxonomy
    @category_taxonomy ||= wp_term_taxonomies.find_by(taxonomy: 'category')
  end

  def thumbnail
    return @thumbnail if defined? @thumbnail

    @thumbnail = WpPost.find_by(id: wp_postmeta.find_by(meta_key: '_thumbnail_id').try!(:meta_value))
  end

  def thumbnail_url
    return unless thumbnail

    [ASSET_DIR, URI(thumbnail.guid).path.split('/').last(3)].join('/')
  end

  def convert_image_url
    doc = Nokogiri::HTML(post_content)

    links = {}

    doc.search('img').each do |element|
      original_src = element['src']
      new_src = yield(original_src)
      links[original_src] = new_src
      element['src'] = new_src
    end

    links.each do |original_src, new_src|
      doc.search("a[href='#{original_src}']").each do |element|
        element['href'] = new_src
      end
    end

    self.post_content = doc.search('body')[0].inner_html
  end

  def markdown_body
    ReverseMarkdown.convert(post_content).gsub("\r", "\n")
  end
end

class WpPostmetum < WpApplicationRecord
end

class WpTermRelationship < WpApplicationRecord
  belongs_to :wp_post, foreign_key: :object_id
  belongs_to :wp_term_taxonomy, foreign_key: :term_taxonomy_id
end

class WpTermTaxonomy < WpApplicationRecord
  self.table_name = :wp_term_taxonomy
  self.primary_key = :term_taxonomy_id

  has_many :wp_term_relationships, foreign_key: :term_taxonomy_id
  has_many :wp_posts, through: :wp_term_relationships

  belongs_to :wp_term, foreign_key: :term_id
end

class WpTerm < WpApplicationRecord
  self.primary_key = :term_id

  has_many :wp_term_taxonomies, foreign_key: :term_id
  has_many :wp_posts, through: :wp_term_taxonomies
end

site = Site.find_by!(fqdn: FQDN)

target = WpPost.where('post_status = "publish" OR post_status = "future"').order(:id)

latest_updated_at = site.posts.maximum(:updated_at)
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

    post.update!(
      title:                wp_post.post_title,
      published_at:         wp_post.post_date_gmt,
      body:                 wp_post.markdown_body,
      category:             category,
      remote_thumbnail_url: wp_post.thumbnail_url,
      updated_at:           wp_post.post_modified_gmt
    )
  end
end
