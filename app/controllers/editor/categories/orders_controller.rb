class Editor::Categories::OrdersController < Editor::ApplicationController
  def update
    category = categories.find(params[:category_id])
    target_category = case params[:direction]
                      when "left"
                        category.higher_items.last
                      when "right"
                        category.lower_items.first
                      else
                        raise "Unknown direction: #{params[:direction]}"
                      end
    if target_category
      category.move_to(target_category, direction: params[:direction])
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

  def category_params
    params.require(:category).permit(
      :category_id,
      :direction
    )
  end
end
