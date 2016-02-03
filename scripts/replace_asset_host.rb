RELATIVE_ASSET_HOST = ARGV[0]

raise "RELATIVE_ASSET_HOST is required." if RELATIVE_ASSET_HOST.blank?

p "* target: #{Post.count}"

Post.transaction do
  Post.find_each.with_index(1) do |post, i|
    p i
    post.body = post.body.gsub(/([^:])#{Regexp.escape(RELATIVE_ASSET_HOST)}/, "\\1https:#{RELATIVE_ASSET_HOST}")
    post.save!
  end
end
