after "development:sites" do
  site1 = Site.find_by!(name: "site1")

  site1.participants.create!(
    name: "name11",
    summary: "summary11",
    description: <<~EOS
      # Hello
      description11
    EOS
  )
  site1.participants.create!(
    name: "name12",
    summary: "summary12",
    description: <<~EOS
      # Hello
      description12
    EOS
  )
end
