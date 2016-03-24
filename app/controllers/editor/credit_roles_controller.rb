class Editor::CreditRolesController < Editor::ApplicationController
  def index
    @credit_roles = credit_roles.order(:order)
  end

  def show
    @credit_role = credit_roles.find(params[:id])
  end

  def new
    @credit_role = credit_roles.build
  end

  def create
    @credit_role = credit_roles.build(credit_role_params)

    if @credit_role.save
      redirect_to [:editor, @credit_role], notice: '役割が作成されました'
    else
      render :new
    end
  end

  def edit
    @credit_role = credit_roles.find(params[:id])
  end

  def update
    @credit_role = credit_roles.find(params[:id])

    if @credit_role.update(credit_role_params)
      redirect_to [:editor, @credit_role], notice: '役割が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @credit_role = credit_roles.find(params[:id])

    @credit_role.destroy

    redirect_to editor_credit_roles_url, notice: '役割が削除されました'
  end

  private

  def credit_roles
    current_site.credit_roles
  end

  def credit_role_params
    params.require(:credit_role).permit(:name, :order)
  end
end
