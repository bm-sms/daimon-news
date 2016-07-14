require "test_helper"

class ParticipantTest < ActionDispatch::IntegrationTest
  setup do
    @site = create(:site)
    @participant = create(:participant, :with_photo, site: @site)

    switch_domain(@site.fqdn)
  end

  test "should have the name, photo, description and written posts of a participant" do
    visit("/participants/#{@participant.id}")

    within ".participant__header" do
      assert page.has_content?("Author")
      assert_equal("face.png", File.basename(find("img").native["src"]))
    end

    within ".participant__body" do
      assert page.has_content?("Awesome description")
    end

    # TODO: check whether the posts written by a participant exists
  end
end
