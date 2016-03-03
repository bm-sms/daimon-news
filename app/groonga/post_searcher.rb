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

  def search_with_fallback_to_first_page(query, page: nil, size: nil)
    search(query, page: page, size: size)
  rescue Groonga::TooSmallPage, Groonga::TooLargePage
    search(query, page: 1, size: size)
  end

  def search(query, page: nil, size: nil)
    posts = @posts.select do |record|
      conditions = []
      conditions << (record.published_at > 0)
      conditions << (record.published_at <= Time.now)
      conditions << (record.site._key == query.site_id)
      if query.participant_id.present?
        conditions << (record.participants =~ query.participant_id)
      end
      if query.keywords.present?
        full_text_search = record.match(query.keywords) do |target|
          (target.index('Terms.Posts_title') * 10) |
            target.index('Terms.Posts_content')
        end
        conditions << full_text_search
      end
      conditions
    end

    result_set = PostSearchResultSet.new
    result_set.participants = group(posts, 'participants')
    result_set.categories = group(posts, 'category')
    unless query.present?
      result_set.posts = EmptyPosts.new
      return result_set
    end

    page = (page || 1).to_i
    size = (size || 100).to_i
    sorted_posts = posts.paginate([['_score', :desc]],
                                  page: page,
                                  size: size)
    sorted_posts.extend(Kaminalize)
    result_set.posts = sorted_posts

    result_set
  end

  def group(posts, key)
    posts.group(key).sort([['_nsubrecs', :desc]], limit: 5)
  end

  module Kaminalize
    def entry_name
      'post'
    end

    def offset_value
      (start_offset || 1) - 1
    end

    def limit_value
      page_size
    end

    def total_pages
      n_pages
    end

    def total_count
      n_records
    end
  end

  class EmptyPosts
    def each
    end

    def total_pages
      0
    end

    def empty?
      true
    end
  end
end
