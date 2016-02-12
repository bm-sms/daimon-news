require 'test_helper'

class UploadImagesTest < ActionDispatch::IntegrationTest
  setup do
    site = create(:site, fqdn: '127.0.0.1')
    user = create(:user, sites: [site])
    login_as_editor(site: site, editor: user)
  end

  attribute :js, true
  test 'Upload images' do
    click_on '記事'

    click_on 'New Post'

    upload_images(File.join(fixture_path, 'images/daimon.png'), File.join(fixture_path, 'images/daimon2.png'))

    assert find('.ace_content').has_content?('![](/uploads/image/image/1/daimon.png) ![](/uploads/image/image/2/daimon2.png)')
  end
end
