after "development:sites" do
  site1 = Site.find_by!(name: "site1")

  site1.participants.create!(
    name: "name11",
    summary: "summary11"
  )
  site1.participants.create!(
    name: "name12",
    summary: "summary12"
  )
end
