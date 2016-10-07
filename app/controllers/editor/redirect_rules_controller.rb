class Editor::RedirectRulesController < Editor::ApplicationController
  def edit
    @site = current_site
  end

  def update
    @site = current_site
    if @site.update(decode(redirect_rule_params))
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

  def decode(params)
    params["redirect_rules_attributes"].map do |rule|
      rule[1]["request_path"] = URI.decode_www_form_component(rule[1]["request_path"])
      rule
    end
    params
  end
end
