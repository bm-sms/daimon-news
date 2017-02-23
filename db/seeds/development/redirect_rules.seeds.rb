after "development:sites" do
  site = Site.find_by!(name: "site1")

  site.redirect_rules.create!(
    request_path: "/old-about",
    destination:  "/about"
  )
  site.redirect_rules.create!(
    request_path: "/company",
    destination:  "http://bm-sms.co.jp/"
  )
end
