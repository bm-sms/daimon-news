require "wp_html_util"

class WpApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'press_'

  class << self
    def connect_to(uri)
      establish_connection(
        adapter:  'mysql2',
        host:     uri.host,
        username: uri.user,
        password: uri.password,
        database: uri.path[1..-1]
      )
    end
  end
end

class WpPost < WpApplicationRecord
  has_many :wp_term_relationships, foreign_key: :object_id
  has_many :wp_term_taxonomies, through: :wp_term_relationships

  has_many :wp_postmeta, foreign_key: :post_id

  include WpHTMLUtil

  def category_taxonomy
    @category_taxonomy ||= wp_term_taxonomies.find_by(taxonomy: 'category')
  end

  def thumbnail
    return @thumbnail if defined? @thumbnail

    @thumbnail = WpPost.find_by(id: wp_postmeta.find_by(meta_key: '_thumbnail_id').try!(:meta_value))
  end

  def thumbnail_url(asset_dir)
    return unless thumbnail

    [asset_dir, URI(thumbnail.guid).path.split('/').last(3)].join('/')
  end


  def markdown_body(&block)
    super(post_content, &block)
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
