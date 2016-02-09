crumb :root do
  link 'Press', root_url
end

crumb :category do |category|
  link category.name, category_url(category.slug)
end

crumb :post do |post|
  link post.title, post_url(post)
  parent :category, post.category
end

crumb :welcome do |welcome|
  link params[:page]
  parent :root
end
