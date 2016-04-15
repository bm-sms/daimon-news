after "development:sites" do
  site1 = Site.find_by!(name: "site1")

  site1.categories.create!(
    name:        "category 1",
    description: "category 1",
    title:       "category 1 title",
    slug:        "category1",
    order:       1
  )
  site1.categories.create!(
    name:        "category 2",
    description: "category 2",
    slug:        "category2",
    order:       2
  )
end
