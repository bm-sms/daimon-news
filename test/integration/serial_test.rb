class SerialTest < ActionDispatch::IntegrationTest
  setup do
    site = create(:site)
    3.times do
      create(:serial, :with_posts, site: site)
    end

    switch_domain(site.fqdn)
  end

  test "/serials" do
    visit "/serials"

    serial_titles = find_all "ul li p.serial-summary__title"
    assert_equal(["Serial 3 (1)", "Serial 2 (1)", "Serial 1 (1)"], serial_titles.map(&:text))

    click_on "Serial 3"

    header = find "h1.serial-header"
    assert_equal("Serial 3", header.text)
  end
end
