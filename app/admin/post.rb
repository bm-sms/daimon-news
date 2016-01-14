ActiveAdmin.register Post do
  permit_params(:site_id, :category_id, :title, :body, :published_at,
                images_attributes: [:id, :image, :_destroy])

  form do |f|
    f.semantic_errors
    f.inputs except: [:source_url, :thumbnail_url]
    f.has_many :images, allow_destroy: true, heading: false, new_record: true do |image_form|
      hint_proc = lambda do
        if image_form.object.image?
          image_form.template.image_tag(image_form.object.image, size: "64x64") +
            image_form.template.text_field_tag(nil, image_form.object.image_url)
        end
      end
      image_form.input(:image, as: :file, hint: hint_proc.call)
    end
    f.actions
  end
end
