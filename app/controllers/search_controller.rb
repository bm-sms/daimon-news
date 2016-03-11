class SearchController < ApplicationController
  def search
    @query = Query.new(search_query_params[:query])
    @query.site_id = current_site.id
    searcher = PostSearcher.new
    @result_set = searcher.search(@query)
    searched_post_ids = @result_set.posts.map(&:_key)
    @posts = Post.includes(:category, credits: [:participant])
               .published.where(id: searched_post_ids)
               .order_by_recently
               .page(params[:page])
               .per(50)
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
