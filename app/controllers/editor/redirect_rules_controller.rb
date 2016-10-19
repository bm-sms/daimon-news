class Editor::RedirectRulesController < Editor::ApplicationController
  def index
    @redirect_rules = redirect_rules.page(params[:page])
  end

  def show
    @redirect_rule = redirect_rules.find(params[:id])
  end

  def new
    @redirect_rule = redirect_rules.build
  end

  def create
    @redirect_rule = redirect_rules.build(redirect_rule_params)

    if @redirect_rule.save
      redirect_to [:editor, @redirect_rule], notice: "リダイレクトが作成されました"
    else
      render :new
    end
  end

  def edit
    @redirect_rule = redirect_rules.find(params[:id])
  end

  def update
    @redirect_rule = redirect_rules.find(params[:id])

    if @redirect_rule.update(redirect_rule_params)
      redirect_to [:editor, @redirect_rule], notice: "リダイレクトルールが更新されました"
    else
      render :edit
    end
  end

  def destroy
    redirect_rules.destroy(params[:id])

    redirect_to editor_redirect_rules_url, notice: "リダイレクトルールが削除されました"
  end

  private

  def redirect_rules
    current_site.redirect_rules
  end

  def redirect_rule_params
    params.require(:redirect_rule).permit(
      :request_path,
      :destination
    )
  end
end
