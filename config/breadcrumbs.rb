crumb :root do
  link "Press", root_url
end

crumb :category do |category|
  link category.name, category_url(category.slug)
end

crumb :series_index do
  link "連載一覧", series_index_url
end

crumb :series do |series|
  link series.title, series_url(series.slug)
  parent :series_index
end

crumb :post do |post|
  link post.title, post_url(post)
  parent :category, post.category
end

crumb :page_num do |page_num, category, series|
  link "#{page_num}ページ目"

  case
  when category
    parent :category, category
  when series
    parent :series, series
  else
    parent :root
  end
end
