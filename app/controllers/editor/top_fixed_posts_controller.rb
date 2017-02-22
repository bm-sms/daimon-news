class Editor::TopFixedPostsController < Editor::ApplicationController
  def index
    @top_fixed_posts = top_fixed_posts.includes(:post).ordered.page(params[:page])
  end

  def new
    @top_fixed_post = top_fixed_posts.build
    @candidate_posts = candidate_posts
  end

  def create
    @top_fixed_post = top_fixed_posts.build(top_fixed_post_params)

    if @top_fixed_post.save
      redirect_to [:editor, :top_fixed_posts], notice: "トップ固定記事の設定が作成されました"
    else
      @candidate_posts = candidate_posts

      render :new
    end
  end

  def edit
    @top_fixed_post = top_fixed_posts.find(params[:id])
    @candidate_posts = candidate_posts
  end

  def update
    @top_fixed_post = top_fixed_posts.find(params[:id])

    if @top_fixed_post.update(top_fixed_post_params)
      redirect_to [:editor, :top_fixed_posts], notice: "トップ固定記事の設定が更新されました"
    else
      @candidate_posts = candidate_posts

      render :edit
    end
  end

  def destroy
    top_fixed_post = top_fixed_posts.find(params[:id])
    top_fixed_post.destroy!

    redirect_to editor_top_fixed_posts_url, notice: "トップ固定記事の設定が削除されました"
  end

  private

  def top_fixed_posts
    current_site.top_fixed_posts
  end

  def top_fixed_post_params
    params.require(:top_fixed_post).permit(
      :post_id,
      :order
    )
  end

  def candidate_posts
    current_site.posts.order_by_recent.published
  end
end
