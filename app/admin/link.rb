ActiveAdmin.register Link do
  permit_params :site_id, :text, :url, :order
end
