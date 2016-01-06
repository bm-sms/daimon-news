ActiveAdmin.register User do
  permit_params :name, :email, :password

  form do |f|
    f.semantic_errors
    f.inputs :name, :email, :password
    f.actions
  end

  index do
    column :name
    column :email

    actions
  end
end
