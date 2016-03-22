class PostSearcher
  class << self
    def search(query_params:, page:, site:)
      query = Query.new(query_params.merge(site_id: site.id))
      groonga_posts = new.search(query)
      PostSearchResultSet.new(groonga_posts: groonga_posts, site: site, query: query, page: page)
    end
  end

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
    return [] unless query.present?

    posts = @posts.select do |record|
      conditions = []
      conditions << (record.published_at > 0)
      conditions << (record.published_at <= Time.now)
      conditions << (record.site._key == query.site_id)

      if query.keywords.present?
        match_target = record.match_target do |target|
          (target.index('Terms.Posts_title') * 10) |
            target.index('Terms.Posts_content')
        end
        keywords = query.keywords.split
        full_text_search = keywords.map {|keyword|
          match_target =~ keyword
        }.inject(&:&)
        full_text_search |= (record.participants.name =~ query.keywords)
        full_text_search |= (record.participants.description =~ query.keywords)
        conditions << full_text_search
      end
      conditions
    end

    posts
  end
end
