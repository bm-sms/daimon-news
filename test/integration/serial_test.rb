require "test_helper"

class SerialTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    1.upto(3) do |i|
      create(:serial, :with_posts, title: "Serial #{i}", slug: "serial#{i}", site: @site)
    end

    switch_domain(@site.fqdn)
  end

  test "/serials" do
    visit "/serials"

    assert_equal("すべての連載 | #{@site.name}", title)

    serial_titles = find_all ".serial-summary__title"
    assert_equal(["Serial 3 (1)", "Serial 2 (1)", "Serial 1 (1)"], serial_titles.map(&:text))

    click_on "Serial 3"

    assert_equal("Serial 3 | #{@site.name}", title)

    header = find ".serial-header"
    assert_equal("Serial 3", header.text)
  end
end
