crumb :root do
  link "Press", root_url
end

crumb :category do |category|
  link category.name, category_url(category.slug)
end

crumb :serials do
  link "連載一覧", serials_url
end

crumb :serial do |serial|
  link serial.title, serial_url(serial.slug)
  parent :serials
end

crumb :post do |post|
  link post.title, post_url(post)
  parent :category, post.category
end

crumb :page_num do |page_num, options|
  link "#{page_num}ページ目"

  if options
    case
    when options[:category]
      parent :category, options[:category]
    when options[:serial]
      parent :serial, options[:serial]
    end
  else
    parent :root
  end
end
