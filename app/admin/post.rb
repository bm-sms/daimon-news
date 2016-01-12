ActiveAdmin.register Post do
  permit_params :site_id, :category_id, :title, :body, :published_at
end
