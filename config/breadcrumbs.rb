crumb :root do
  link "Press", root_url
end

crumb :category do |category|
  link category.name, category_url(category.slug)
  parent :category, category.parent if category.parent
end

crumb :serials do
  link "すべての連載", serials_url
end

crumb :serial do |serial|
  link serial.title, serial_url(serial)
  parent :serials
end

crumb :post do |post|
  link post.title, post_url(public_id: post.public_id)
  if post.categories.present?
    parent :category, post.categories.first
  else
    parent :root
  end
end

crumb :participant do |participant|
  link participant.name, participant_url(participant)
  parent :participants
end

crumb :participants do
  link "すべての執筆関係者", participants_url
end

crumb :page_num do |page_num, options|
  link "#{page_num}ページ目"

  if options
    case
    when options[:category]
      parent :category, options[:category]
    when options[:serial]
      parent :serial, options[:serial]
    when options[:serials]
      parent :serials
    when options[:participant]
      parent :participant, options[:participant]
    when options[:participants]
      parent :participants
    end
  else
    parent :root
  end
end
