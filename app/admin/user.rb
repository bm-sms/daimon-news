ActiveAdmin.register User do
  permit_params :name, :email, :password, :role

  form do |f|
    f.semantic_errors
    f.inputs :name, :email, :password, :role
    f.actions
  end

  index do
    column :name
    column :email
    column :role

    actions
  end
end
