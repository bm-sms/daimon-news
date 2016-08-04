class Editor::PostsController < Editor::ApplicationController
  helper_method :current_category

  def index
    @posts = posts.preload(:categories).order_by_recent.page(params[:page]).per(50)
  end

  def show
    @post = posts.find_by!(public_id: params[:public_id])
  end

  def new
    if current_site.multiple_categories_enabled?
      @post = posts.build
    else
      @post = posts.build(categorizations_attributes: [{order: 1}])
    end
  end

  def create
    @post = posts.build(post_params)

    if @post.save
      redirect_to editor_post_url(public_id: @post.public_id), notice: "記事が作成されました。"
    else
      render :new
    end
  end

  def edit
    @post = posts.find_by!(public_id: params[:public_id])
  end

  def update
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
      :serial_id,
      :thumbnail,
      :published_at,
      credits_attributes: [
        :id,
        :order,
        :participant_id,
        :credit_role_id,
        :_destroy
      ],
      categorizations_attributes: [
        :id,
        :category_id,
        :order,
        :_destroy
      ]
    )
  end

  def currenr_category
    @post.main_category
  end
end
