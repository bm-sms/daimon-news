ActiveAdmin.register MetaTag do
permit_params :path, :description, :keywords, :noindex, :site_id
end
