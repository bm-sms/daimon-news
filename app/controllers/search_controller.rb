class SearchController < ApplicationController
  def search
    @query = Query.new(search_query_params[:query])
    @query.site_id = current_site.id
    searcher = PostSearcher.new
    @result_set = searcher.search(@query)
    searched_post_ids = @result_set.posts.map(&:_key)
    selected_posts = Post.includes(:category, credits: [:participant, :role])
                       .published.where(id: searched_post_ids)
                       .order_by_recently
    @role_names = selected_posts.map {|post|
      post.credits.map do |credit|
        credit.role.name
      end
    }.flatten.uniq
    @posts = selected_posts.page(params[:page]).per(50)
  end

  private

  def search_query_params
    params.permit(query: [
      :keywords,
      :site_id,
      :participant_id,
      :category_id,
    ])
  end
end
