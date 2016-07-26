class Editor::Categories::OrdersController < Editor::ApplicationController
  def update
    category = categories.find(params[:category_id])
    target_category = categories.find(params[:target])
    category.move_to(target_category, direction: params[:move_to])

    redirect_to :back, notice: "カテゴリ「#{category.name}」を移動しました"
  end

  private

  def categories
    current_site.categories
  end
end
