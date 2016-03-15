class SearchController < ApplicationController
  def search
    @search_result = PostSearcher.search(query_params: search_query_params, page: params[:page], site: current_site)
  end

  private

  def search_query_params
    params.require(:query).permit(:keywords)
  end
end
