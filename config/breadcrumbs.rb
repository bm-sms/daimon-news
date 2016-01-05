crumb :root do
  link 'Press', root_path
end

crumb :category do |category|
  link category.name, category_path(category.slug)
end

crumb :post do |post|
  link post.title, post_path(post)
  parent :category, post.category
end
