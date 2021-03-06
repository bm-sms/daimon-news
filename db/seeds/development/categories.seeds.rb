after "development:sites" do
  site1 = Site.find_by!(name: "site1")

  (1..100).each do |n|
    site1.categories.create!(
      name:        "category #{n}",
      description: "category #{n}",
      slug:        "category#{n}",
      order:       n
    )
  end

  category3 = site1.categories.find_by!(slug: "category3")

  category3_1 = category3.children.create!(
    name:        "category 3-1",
    description: "category 3-1",
    slug:        "category3_1",
    site:        site1,
    order:       1
  )
  category3.children.create!(
    name:        "category 3-2",
    description: "category 3-2",
    slug:        "category3_2",
    site:        site1,
    order:       2
  )
  category3.children.create!(
    name:        "category 3-3",
    description: "category 3-3",
    slug:        "category3_3",
    site:        site1,
    order:       3
  )
  category3_1.children.create!(
    name:        "category 3-1-1",
    description: "category 3-1-1",
    slug:        "category3_1_1",
    site:        site1,
    order:       1
  )
  category3_1.children.create!(
    name:        "category 3-1-2",
    description: "category 3-1-2",
    slug:        "category3_1_2",
    site:        site1,
    order:       2
  )
  category3_1.children.create!(
    name:        "category 3-1-3",
    description: "category 3-1-3",
    slug:        "category3_1_3",
    site:        site1,
    order:       3
  )
  category3_1.children.create!(
    name:        "category 3-1-4",
    description: "category 3-1-4",
    slug:        "category3_1_4",
    site:        site1,
  )
end
