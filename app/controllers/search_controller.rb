class SearchController < ApplicationController
  def search
    @query = Query.new(params[:query])
    searcher = PostSearcher.new
    @posts = searcher.search(@query, page: params[:page])
  end
end
