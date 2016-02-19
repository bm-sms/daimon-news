require "activerecord-import"

filename, fqdn = ARGV

DUMMY_THUMBNAIL = File.open(Rails.root + "test/fixtures/images/face.png")

rows = []
File.open(filename, "r") do |file|
  header_line = file.gets.chomp
  headers = header_line.split("\t")
  file.each_line do |line|
    row = {}
    line.chomp
    fields = line.split("\t")
    headers.zip(fields).each do |key, value|
      row[key] = value
    end
    next if row["post_content"].blank?
    rows << row
  end
end

max_id = Post.maximum(:id)
if max_id
  ActiveRecord::Base.connection.execute("SELECT setval('posts_id_seq', #{max_id+1});")
else
  puts "max_id is nil"
end

site = Site.find_or_create_by!(fqdn: fqdn) do |s|
  s.name = fqdn
end

category = nil

site.transaction do
  category = site.categories.find_or_create_by!(name: "uncategorized") do |c|
    c.description = "uncategolized posts"
    c.slug = "uncategorized"
    c.order = 0
  end
end

puts "Total: #{rows.size}"

def save_rows!(site, category, rows)
  posts = []
  rows.each do |row|
    post = site.posts.find_or_initialize_by(public_id: row["ID"])
    post.assign_attributes(title: row["post_title"],
                           published_at: row["post_date_gmt"],
                           body: row["post_content"],
                           category: category,
                           thumbnail: DUMMY_THUMBNAIL,
                           original_updated_at: row["post_modified_gmt"],
                           original_source: row["post_content"],
                           updated_at: row["post_modified_gmt"])
    posts << post if post.new_record?
  end
  unless posts.empty?
    Post.import(posts)
    puts "Import #{posts.size} rows"
  end
end

rows.each_slice(500) do |_rows|
  site.transaction do
    save_rows!(site, category, _rows)
  end
end

DUMMY_THUMBNAIL.close
