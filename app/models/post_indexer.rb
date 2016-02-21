class PostIndexer
  def initialize
    @sites = Groonga['Sites']
    @categories = Groonga['Categories']
    @authors = Groonga['Authors']
    @posts = Groonga['Posts']
  end

  def add(post)
    site = @sites.add(post.site_id)
    if post.category_id
      category = @categories.add(post.category_id,
                                 name: post.category.name)
    else
      category = nil
    end
    if post.author_id
      author = @authors.add(post.author_id,
                            name: post.author.name)
    else
      author = nil
    end
    @posts.add(post.id,
               title: post.title,
               content: extract_content(post),
               published_at: post.published_at,
               site: site,
               category: category,
               author: author,
               public_id: post.public_id)
  end

  def remove(post)
    @posts[post.id].delete
  end

  private

  def extract_content(post)
    post.body
  end
end
