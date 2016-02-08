require "fileutils"

FileUtils.mkdir_p("tmp/pandoc")
FileUtils.mkdir_p("tmp/reverse_markdown")
FileUtils.mkdir_p("tmp/kramdown")

Post.all.each.with_index(1) do |post, index|
  File.write("tmp/pandoc/#{post.id}.txt", post.markdown_text)
  File.write("tmp/reverse_markdown/#{post.id}.txt", post.reverse_markdown_text)
  File.write("tmp/kramdown/#{post.id}.txt", post.kramdown_text)
end
