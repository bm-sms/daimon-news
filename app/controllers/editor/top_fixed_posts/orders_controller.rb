class Editor::TopFixedPosts::OrdersController < Editor::ApplicationController
  def update
    top_fixed_post = top_fixed_posts.find(params[:top_fixed_post_id])
    target_top_fixed_post = top_fixed_posts.find(params[:target])

    if top_fixed_post.move_to(direction: params[:move_to], target: target_top_fixed_post)
      redirect_to :back, notice: "トップ固定記事「#{top_fixed_post.post.title}」を移動しました"
    else
      redirect_to :back, alert: "トップ固定記事「#{top_fixed_post.post.title}」を移動できませんでした"
    end
  end

  private

  def top_fixed_posts
    current_site.top_fixed_posts
  end
end
