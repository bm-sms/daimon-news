class Editor::Categories::OrdersController < Editor::ApplicationController
  def update
    category = categories.find(params[:category_id])
    target_category = categories.find(params[:target])
    Category.swap_order(category, target_category)

    redirect_to :back, notice: "カテゴリ「#{category.name}」を移動しました"
  end

  private

  def categories
    current_site.categories
  end
end
