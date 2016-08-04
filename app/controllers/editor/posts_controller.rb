class Editor::PostsController < Editor::ApplicationController
  def index
    @posts = posts.preload(:category).order_by_recent.page(params[:page]).per(50)
  end

  def show
    @post = posts.find_by!(public_id: params[:public_id])
  end

  def new
    redirect_to editor_posts_url, notice: "現在記事の作成・編集はできません。しばらく時間を置いてアクセスしてください。"
  end

  def create
    redirect_to editor_posts_url, notice: "現在記事の作成・編集はできません。しばらく時間を置いてアクセスしてください。"
    return
    @post = posts.build(post_params)

    if @post.save
      redirect_to editor_post_url(public_id: @post.public_id), notice: "記事が作成されました。"
    else
      render :new
    end
  end

  def edit
    redirect_to editor_posts_url, notice: "現在記事の作成・編集はできません。しばらく時間を置いてアクセスしてください。"
  end

  def update
    redirect_to editor_posts_url, notice: "現在記事の作成・編集はできません。しばらく時間を置いてアクセスしてください。"
    return
    @post = posts.find_by!(public_id: params[:public_id])

    if @post.update(post_params)
      redirect_to editor_post_url(public_id: @post.public_id), notice: "記事が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @post = posts.find_by!(public_id: params[:public_id])

    @post.destroy

    redirect_to editor_posts_url, notice: "記事が削除されました。"
  end

  def preview
    @post = posts.find_by!(public_id: params[:public_id])

    @pages =
      if params[:all]
        @post.pages.page(1).per(@post.pages.size)
      else
        @post.pages.page(params[:page]).per(1)
      end

    render template: "posts/show", layout: "preview"
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
      :serial_id,
      :thumbnail,
      :published_at,
      credits_attributes: [
        :id,
        :order,
        :participant_id,
        :credit_role_id,
        :_destroy
      ]
    )
  end
end
