class PostIndexer
  def initialize
    @sites = Groonga['Sites']
    @categories = Groonga['Categories']
    @authors = Groonga['Authors']
    @posts = Groonga['Posts']
  end

  def add(post)
    return if @posts.nil?
    site = @sites.add(post.site_id)
    category = @categories.add(post.category_id)
    if post.author_id
      author = @authors.add(post.author_id)
    else
      author = nil
    end
    @posts.add(post.id,
               title: post.title,
               content: extract_content(post),
               published_at: post.published_at,
               site: site,
               category: category,
               author: author)
  end

  def remove(post)
    return if @posts.nil?
    @posts[post.id].delete
  end

  private

  def extract_content(post)
    post.body
  end
end
