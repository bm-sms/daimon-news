class PostSearcher
  def initialize
    @posts = Groonga['Posts']
  end

  def related_post_ids(post, limit: 5)
    return [] if @posts.nil?

    related_posts = @posts.select do |record|
      conditions = (record.index('Words.Posts_title').similar_search(post.title))
      conditions |= (record.index('Words.Posts_content').similar_search(post.body))
      post.credits.each do |credit|
        conditions |= (record.participants._key =~ credit.participant_id)
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

  def search(query)
    posts = @posts.select do |record|
      conditions = []
      conditions << (record.published_at > 0)
      conditions << (record.published_at <= Time.now)
      conditions << (record.site._key == query.site_id)

      if query.keywords.present?
        full_text_search = record.match(query.keywords) do |target|
          (target.index('Terms.Posts_title') * 10) |
            target.index('Terms.Posts_content')
        end
        full_text_search |= (record.participants.name =~ query.keywords)
        full_text_search |= (record.participants.description =~ query.keywords)
        conditions << full_text_search
      end
      conditions
    end

    result_set = PostSearchResultSet.new
    result_set.participants = group(posts, 'participants')
    result_set.categories = group(posts, 'category')
    unless query.present?
      result_set.posts = []
      return result_set
    end

    result_set.posts = posts

    result_set
  end

  def group(posts, key)
    posts.group(key).sort([['_nsubrecs', :desc]], limit: 5)
  end
end
