require "optparse"
require "wp_html_util"

parser = OptionParser.new

parser.banner = <<BANNER
Usage:
  $ bin/rails r scripts/convert_image.rb [runner options] -- [options] <fqdn>
BANNER

force = false

parser.on("--force", "Force convert all image URI") do
  force = true
end

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
end

Site.class_eval do
  has_many :lite_posts
end

site = Site.find_by!(fqdn: fqdn)

posts = if force
  site.lite_posts
else
  site.lite_posts.where(replaced_html: nil)
end

posts.all.each do |post|
  puts post.public_id
  site.transaction do
    replaced_html = post.preprocess do |url|
      image = site.images.create!(remote_image_url: url)
      image.image_url
    end
    post.replaced_html = replaced_html
    post.save!
  end
end
