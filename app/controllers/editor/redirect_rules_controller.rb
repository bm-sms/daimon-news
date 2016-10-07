class Editor::RedirectRulesController < Editor::ApplicationController
  def edit
    @site = current_site
  end

  def update
    @site = current_site

    if @site.update(redirect_rule_params)
      redirect_to [:editor, :redirect_rules], notice: "リダイレクトルールが更新されました"
    else
      flash.now[:alert] = "リダイレクトルールが更新されませんでした"
      render :edit, locals: {errors: @site.errors}
    end
  end

  private

  def redirect_rule_params
    params.require(:site).permit(redirect_rules_attributes: [:id, :request_path, :destination, :_destroy])
  end
end
