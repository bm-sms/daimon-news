ActiveAdmin.register PageMetaInformation do
permit_params :path, :description, :keywords, :noindex, :site_id
end
