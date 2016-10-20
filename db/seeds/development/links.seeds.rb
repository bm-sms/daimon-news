after "development:sites" do
  site = Site.find_by!(name: "site1")

  site.links.create!(
    text:  "about",
    url:   "/about",
    order: 1
  )
  site.links.create!(
    text:  "policy",
    url:   "/policy",
    order: 2
  )
  site.links.create!(
    text:  "company",
    url:   "http://bm-sms.co.jp/",
    order: 3
  )
end
