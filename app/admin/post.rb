ActiveAdmin.register Post do
  permit_params(:site_id, :category_id, :title, :body, :published_at,
                images_attributes: [:id, :image, :_destroy])

  form do |f|
    f.semantic_errors
    f.inputs except: [:source_url, :thumbnail_url]
    f.actions
  end
end
