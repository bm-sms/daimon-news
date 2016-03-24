class Editor::PostsController < Editor::ApplicationController
  def index
    @posts = posts.preload(:category).order_by_recently.page(params[:page]).per(50)
  end

  def show
    @post = posts.find_by!(public_id: params[:id])
  end

  def new
    @post = posts.build
  end

  def create
    @post = posts.build(post_params)

    if @post.save
      redirect_to [:editor, @post], notice: '記事が作成されました。'
    else
      render :new
    end
  end

  def edit
    @post = posts.find_by!(public_id: params[:id])
  end

  def update
    @post = posts.find_by!(public_id: params[:id])

    if @post.update(post_params)
      redirect_to [:editor, @post], notice: '記事が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @post = posts.find_by!(public_id: params[:id])

    @post.destroy

    redirect_to editor_posts_url, notice: '記事が削除されました。'
  end

  def preview
    @post = posts.find_by!(public_id: params[:id])

    @pages =
      if params[:all]
        Kaminari.paginate_array(@post.pages).page(1).per(@post.pages.size)
      else
        Kaminari.paginate_array(@post.pages).page(params[:page]).per(1)
      end

    render template: 'posts/show', layout: 'preview'
  end

  private

  def posts
    current_site.posts
  end

  def post_params
    params.require(:post).permit(
      :public_id,
      :title,
      :body,
      :category_id,
      :thumbnail,
      :published_at,
      :credits_attributes => [
        :id,
        :participant_id,
        :credit_role_id,
        :_destroy
      ]
    )
  end
end
