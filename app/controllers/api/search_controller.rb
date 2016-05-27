class Api::SearchController < Api::ApplicationController
  def search
    search_result = PostSearcher.search(query_params: search_query_params, page: params.dig(:page, :number), site: current_site)
    search_result.extend(PostSearchResultSetDecorator)
    posts = search_result.posts
    posts.each do |post|
      post.snippet = search_result.excerpt(post)
    end
    render json: search_result.posts, include: "category"
  end

  private

  def search_query_params
    params.require(:filter).permit(:keywords)
  end
end
