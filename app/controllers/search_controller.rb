class SearchController < ApplicationController
  def search
    @query = Query.new(params[:query])
    @query.site_id = current_site.id
    searcher = PostSearcher.new
    @result_set = searcher.search_with_fallback_to_first_page(@query, page: params[:page])
  end
end
