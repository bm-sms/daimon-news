class SearchController < ApplicationController
  def search
    @query = Query.new(search_params[:query])
    @query.site_id = current_site.id
    searcher = PostSearcher.new
    @result_set = searcher.search_with_fallback_to_first_page(@query, page: search_params[:page])
  end

  def search_params
    params.permit(:page, query: [:keywords, :participant_id, :site_id])
  end
end
