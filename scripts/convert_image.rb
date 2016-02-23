require "optparse"

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

Post.class_eval do
  include WpHTMLUtil

  def preprocess(&block)
    super(original_source, &block)
  end
end

site = Site.find_by!(fqdn: fqdn)

posts = if force
  site.posts.all
else
  site.posts.where(replaced_html: nil).all
end

site.posts.all.each do |post|
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
