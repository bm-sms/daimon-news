after "development:sites" do
  site1 = Site.find_by!(name: "site1")

  site1.fixed_pages.create!(
    slug:  "about",
    title: "About Site 1",
    body: <<~EOS,
    Site 1 is:

    - A
    - B
    - C
    EOS
  )
  site1.fixed_pages.create!(
    slug:  "policy",
    title: "Privacy Policy",
    body: <<~EOS,
    ## Privacy Policy

    - A

    ## Information

    hi
    EOS
  )
end
