class Editor::PickupPostsController < Editor::ApplicationController
  def index
    @pickup_posts = pickup_posts.order(:order).page(params[:page]).per(200)
  end

  def new
    @pickup_post = PickupPost.new
  end

  def create
    @pickup_post = PickupPost.new(pickup_post_params)

    if @pickup_post.save
      redirect_to [:editor, :pickup_posts], notice: "ピックアップ記事の設定が作成されました"
    else
      render :new
    end
  end

  def edit
    @pickup_post = pickup_posts.find(params[:id])
  end

  def update
    @pickup_post = pickup_posts.find(params[:id])

    if @pickup_post.update(pickup_post_params)
      redirect_to [:editor, :pickup_posts], notice: "ピックアップ記事の設定が更新されました"
    else
      render :edit
    end
  end

  def destroy
    @pickup_post = pickup_posts.find(params[:id])
    @pickup_post.destroy

    redirect_to editor_pickup_posts_url, notice: "ピックアップ記事の設定が削除されました"
  end

  private

  def pickup_posts
    PickupPost.includes(:post).where(posts: {site_id: current_site.id})
  end

  def pickup_post_params
    params.require(:pickup_post).permit(
      :post_id,
      :order
    )
  end
end
