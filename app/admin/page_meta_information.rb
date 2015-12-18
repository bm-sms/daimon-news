ActiveAdmin.register PageMetaInformation do
  permit_params :path, :title, :description, :keywords, :noindex, :site_id
end
