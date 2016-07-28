class Editor::Categories::OrdersController < Editor::ApplicationController
  def update
    category = categories.find(params[:category_id])
    target_category = categories.find(params[:target])

    if category.move_to(direction: params[:move_to], target: target_category)
      redirect_to :back, notice: "カテゴリ「#{category.name}」を移動しました"
    else
      redirect_to :back, alert: "カテゴリ「#{category.name}」を移動できませんでした"
    end
  end

  private

  def categories
    current_site.categories
  end
end
