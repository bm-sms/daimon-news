class SearchController < ApplicationController
  def search
    @query = Query.new(params[:query])
    @query.site_id = current_site.id
    searcher = PostSearcher.new
    @result_set = searcher.search(@query, page: params[:page])
  end
end
