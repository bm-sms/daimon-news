require "wp_html_validator"

parser = OptionParser.new

parser.banner = <<BANNER
Usage
  $ bin/rails r scripts/convert_html2md.rb [options] <fqdn> [id]
BANNER

dry_run = false
stop_on_error = false

parser.on("--dry-run", "Dry run") do
  dry_run = true
end

parser.on("--stop-on-error", "Stop on error") do
  stop_on_error = true
end

argv = ARGV.dup
argv.shift

begin
  parser.parse!(argv)
rescue OptionParser::ParseError => ex
  $stderr.puts ex.message
  $stderr.puts parser.help
  exit(false)
end

module Converter
  refine Post do
    include WpHTMLUtil

    def markdown_body(&block)
      super(original_html, &block)
    end

    def validate!(stop_on_error)
      validator = WpHTMLValidator.new(id, original_html)
      if stop_on_error
        validator.validate!
      else
        validator.validate(display_error: true)
      end
    end
  end
end

using Converter

fqdn, id = argv

site = Site.find_by(fqdn: fqdn)

site.transaction do
  if id
    post = site.posts.where(id: id).first
    post.validate!(stop_on_error)
    unless dry_run
      post.body = post.markdown_body do |url|
        image = site.images.create!(remote_image_url: url)
        image.image_url
      end
      post.save!
    end
  else
    puts "Target records: #{site.posts.count}"
    n_errors = 0
    site.posts.each do |_post|
      if _post.validate!(stop_on_error)
        unless dry_run
          _post.body = post.markdown_body do |url|
            image = site.images.create!(remote_image_url: url)
            image.image_url
          end
          _post.save!
        end
      else
        n_errors += 1
      end
    end
    puts "Errors: #{n_errors}"
  end
end
