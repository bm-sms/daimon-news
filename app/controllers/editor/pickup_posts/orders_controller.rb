class Editor::PickupPosts::OrdersController < Editor::ApplicationController
  def update
    pickup_post = pickup_posts.find(params[:pickup_post_id])
    target_pickup_post = pickup_posts.find(params[:target])

    if pickup_post.move_to(direction: params[:move_to], target: target_pickup_post)
      redirect_to :back, notice: "ピックアップ記事「#{pickup_post.post.title}」を移動しました"
    else
      redirect_to :back, alert: "ピックアップ記事「#{pickup_post.post.title}」を移動できませんでした"
    end
  end

  private

  def pickup_posts
    current_site.pickup_posts
  end
end
