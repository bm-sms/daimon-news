ActiveAdmin.register User do
  permit_params :name, :email, :password, :role

  index do
    column :name
    column :email
    column :role

    actions
  end
end
