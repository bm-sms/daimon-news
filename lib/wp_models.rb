require "wp_html_util"

class WpApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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

  def convert_image_url(doc)
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
  end

  def markdown_body
    return @markdown_text if @markdown_text

    html = Nokogiri::HTML(post_content).tap {|doc|
      convert_image_url(doc) do |original_src|
        # TODO replace original_src with new_src
        original_src
      end
      convert_u_to_strong(doc)
    }.search('body')[0].inner_html

    @markdown_text = html.split(Page::SEPARATOR).map {|page|
      PandocRuby.convert(page,
                         {
                           from: :html,
                           to: 'markdown_github'
                         },
                         "atx-header")
    }.join(Page::SEPARATOR + "\n")
      .gsub('****', '<br>') # XXX Workaround for compatibility
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
