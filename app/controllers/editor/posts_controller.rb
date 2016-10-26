class Editor::PostsController < Editor::ApplicationController
  helper_method :current_category

  def index
    conditions = {}
    @search_query_params = {}
    if params[:query].present?
      @search_query_params = search_query_params
      conditions[:id] = Editor::PostSearcher.search_post_ids(query_params: search_query_params, page: params[:page], site: current_site)
      conditions[:public_id] = search_query_params[:public_id] if search_query_params[:public_id].present?
      if search_query_params[:category_id].present?
        conditions[:categories] = {}
        conditions[:categories][:id] = search_query_params[:category_id]
      end
    end
    @posts = posts.includes(:categories).where(conditions).order_by_recent.page(params[:page]).per(50)
  end

  def show
    @post = posts.find_by!(public_id: params[:public_id])
  end

  def new
    @post = posts.build
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

  def search_query_params
    params.require(:query).permit(:public_id, :title, :category_id)
  end
end
