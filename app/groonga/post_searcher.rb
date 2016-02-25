class PostSearcher
  def initialize
    @posts = Groonga['Posts']
  end

  def related_post_ids(post, limit: 5)
    related_posts = @posts.select do |record|
      conditions = (record.index('Words.Posts_title').similar_search(post.title))
      conditions |= (record.index('Words.Posts_content').similar_search(post.body))
      if post.author
        conditions |= (record.author._key == post.author.id)
      end
      if post.category
        conditions |= (record.category._key == post.category.id)
      end
      conditions &
        (record.published_at <= Time.now) &
        (record.site._key == post.site_id) &
        (record._key != post.id)
    end
    related_posts.sort([["_score", :desc]], limit: limit).map do |related_post|
      related_post._key
    end
  end
end
