ActiveAdmin.register Post do
  permit_params :site_id, :category_id, :title, :body, :published_at, images_attributes: [:id, :image, :_destroy]

  form do |f|
    f.semantic_errors
    f.inputs except: [:source_url, :thumbnail_url]
    f.has_many :images, allow_destroy: true, heading: false, new_record: true do |image_form|
      image_form.input :image, as: :file, hint: image_form.template.image_tag(image_form.object.image)
    end
    f.actions
  end
end
