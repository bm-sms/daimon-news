parser = OptionParser.new

parser.banner = <<BANNER
Usage
  $ bin/rails r scripts/dump_html.rb [runner options] -- [options]
BANNER

base_directory = nil
fqdn = nil
public_id = nil

parser.on("-b", "--base-dir=BASE_DIR", "Output files here") do |dir|
  base_directory = Pathname(dir)
end

parser.on("--fqdn=FQDN", "FQDN") do |_fqdn|
  fqdn = _fqdn
end

parser.on("--public-id=ID", "Public ID") do |id|
  public_id = id
end

parser.on("-e", "--environment=NAME", "Rails environment. This option is handled by `bin/rails r`") do |name|
  # NOP
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

unless base_directory
  $stderr.puts "--base-dir is required."
  $stderr.puts parser.help
  exit(false)
end

posts = nil

if fqdn
  site = Site.find_by!(fqdn: fqdn)
  if public_id
    posts = [site.posts.find_by(public_id: public_id)]
  else
    posts = site.posts
  end
else
  posts = Post.all
end

include ApplicationHelper

posts.each do |post|
  (base_directory + post.site.fqdn).mkpath
  path = (base_directory + post.site.fqdn + "#{post.public_id}.html")
  path.write(render_markdown(post.body))
end
