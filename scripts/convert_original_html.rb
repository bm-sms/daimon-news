require "wp_html_util"

parser = OptionParser.new

parser.banner = <<BANNER
Usage
  $ bin/rails r scripts/convert_original_html.rb [runner options] -- [options] <fqdn>
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

Post.class_eval do
  include WpHTMLUtil

  def preprocess(&block)
    super(stripped_html, &block)
  end
end


fqdn = argv[0]

site = Site.find_by!(fqdn: fqdn)

site.transaction do
  site.posts.each do |post|
    puts post.public_id
    doc = Nokogiri::HTML(post.original_html)
    article = doc.search("article .post")
    article.search("aside").remove
    article.search("#breadcrumb").remove
    article.search(".ad.banner").remove
    article.search("span.kdate").remove
    article.search(".blogbox").remove
    post.stripped_html = article.inner_html.gsub(/<!--.*-->/, "")
    replaced_html = post.preprocess do |url|
      image = site.images.create!(remote_image_url: url)
      image.image_url
    end
    doc = Nokogiri::HTML(replaced_html)
    doc.search("strong").each do |element|
      if element.inner_html == "<br>\n"
        element.replace("{{br}}\n")
      end
    end
    post.save!
  end
end
