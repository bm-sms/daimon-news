class SearchController < ApplicationController
  def search
    searcher = PostSearcher.new
    @result_set = searcher.search(@query, page: params[:page])
  end
end
