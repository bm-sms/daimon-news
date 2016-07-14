class Editor::CategoriesController < Editor::ApplicationController
  def index
    @categories = categories.roots.ordered
  end

  def show
    @category = categories.find(params[:id])
  end

  def new
    @category = categories.build
  end

  def create
    @category = categories.build(category_params)

    if @category.save
      redirect_to [:editor, @category], notice: "カテゴリが作成されました"
    else
      render :new
    end
  end

  def edit
    @category = categories.find(params[:id])
  end

  def update
    @category = categories.find(params[:id])

    if @category.update(category_params)
      redirect_to [:editor, @category], notice: "カテゴリが更新されました"
    else
      render :edit
    end
  end

  def destroy
    @category = categories.find(params[:id])

    @category.destroy

    redirect_to editor_categories_url, notice: "カテゴリが削除されました"
  end

  # move to left
  def move_higher
    category = categories.find(params[:id])
    target_category = category.higher_items.last
    category.move_to_left_of(target_category) if target_category

    redirect_to editor_categories_url, notice: "カテゴリが移動されました"
  end

  # move to right
  def move_lower
    category = categories.find(params[:id])
    target_category = category.lower_items.first
    category.move_to_right_of(target_category) if target_category

    redirect_to editor_categories_url, notice: "カテゴリが移動されました"
  end

  private

  def categories
    current_site.categories
  end

  def category_params
    params.require(:category).permit(
      :name,
      :description,
      :slug,
      :order,
      :parent_id
    )
  end
end
