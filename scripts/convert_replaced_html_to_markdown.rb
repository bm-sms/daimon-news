require "optparse"
require "wp_html_util"

parser = OptionParser.new

parser.banner = <<BANNER
Usage:
  $ bin/rails r scripts/convert_image.rb [runner options] -- [options] <fqdn>
BANNER

argv = ARGV.dup
argv.delete("--")

begin
  parser.parse!(argv)
rescue OptionParser::ParseError => ex
  $stderr.puts ex.message
  $stderr.puts parser.help
  exit(false)
end


fqdn = argv[0]

class LitePost < ActiveRecord::Base
  include WpHTMLUtil

  self.table_name = :posts

  belongs_to :site
  belongs_to :category
  belongs_to :author

  validates :body, presence: true
  validates :thumbnail, presence: true

  before_save :assign_public_id

  def assign_public_id
    self.public_id ||= (self.class.maximum(:public_id) || 0) + 1
  end

  def preprocess(&block)
    super(original_source, &block)
  end

  def markdown_body(&block)
    super(replaced_html, &block)
  end
end

Site.class_eval do
  has_many :lite_posts
end

site = Site.find_by!(fqdn: fqdn)

site.transaction do
  puts "Target: #{site.lite_posts.count}"
  site.lite_posts.where.not(replaced_html: nil).all.each do |post|
    post.body = post.markdown_body
    post.save!
  end
end
