class Admin::PostsController < Admin::ApplicationController
  def index
    @posts = posts.preload(:category)
  end

  def show
    @post = posts.find(params[:id])
  end

  def new
    @post = posts.build
  end

  def create
    @post = posts.build(post_params)

    if @post.save
      redirect_to [:admin, @post], notice: '記事が作成されました。'
    else
      render :new
    end
  end

  def edit
    @post = posts.find(params[:id])
  end

  def update
    @post = posts.find(params[:id])

    if @post.update_columns(post_params)
      redirect_to [:admin, @post], notice: '記事が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @post = posts.find(params[:id])

    @post.destroy

    redirect_to admin_posts_url, notice: '記事が削除されました。'
  end

  private

  def posts
    current_site.posts
  end

  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :category_id,
      :author_id,
      :thumbnail,
      :published_at
    )
  end
end
