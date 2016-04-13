module Api
  class CategoriesController < ApplicationController
    def show
      category = current_site.categories.find_by!(slug: params[:slug])

      render json: category
    end
  end
end
