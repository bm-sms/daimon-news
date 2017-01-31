class Editor::PostsController < Editor::ApplicationController
  helper_method :current_category

  def index
    @search_query_params = params[:q].present? ? search_query_params : {}
    @search = posts.ransack(@search_query_params)
    @posts = @search.result.includes(:categories).order_by_recent.page(params[:page]).per(50)
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

    @markdown_context = {
      full_text: @post.body,
      fullpath: request.fullpath,
    }
    @markdown_context[:current_page] = params[:page] if params[:page]

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
    params.require(:q).permit(:public_id_eq, :title_cont, :categories_id_eq, :s)
  end
end
