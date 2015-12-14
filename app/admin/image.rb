ActiveAdmin.register Image do
  permit_params :image

  index do
    selectable_column
    column :id
    column :image_url
    column :image do |image|
      image_tag image.image_url, height: 100
    end
    actions
  end
end
