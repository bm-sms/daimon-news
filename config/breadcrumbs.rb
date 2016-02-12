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

crumb :page_num do |page_num, category|
  link "#{page_num}ページ目"

  if category
    parent :category, category
  else
    parent :root
  end
end
