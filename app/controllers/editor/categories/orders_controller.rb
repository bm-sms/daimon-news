class Editor::Categories::OrdersController < Editor::ApplicationController
  def update
    category = categories.find(params[:category_id])
    target_category = categories.find(params[:target])
    if target_category
      category.move_to(target_category, direction: params[:move_to])
      message = "カテゴリ「#{category.name}」を移動しました"
    else
      message = "カテゴリ「#{category.name}」を移動できませんでした"
    end
    redirect_to editor_categories_url, notice: message
  end

  private

  def categories
    current_site.categories
  end
end
