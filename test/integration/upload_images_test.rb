require 'test_helper'

module AdminTestHelper
  def login_as_admin
    site = Site.create!(name: 'daimon-news', fqdn: '127.0.0.1')
    editor = User.create!(email: 'editor@example.com', password: 'password')
    site.memberships.create!(user: editor)

    visit '/editor'

    fill_in 'Email',    with: 'editor@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
  end
end

module MarkdownEditorUploadImageHelper
  def upload_images(*files)
    # XXX bootstrap-markdown-editor's upload button can't click by poltergeist because of its style.
    # The input tag is computed as big square but visible (clickable) area is very small
    # and poltergeist doesn't detect where can be clicked.
    before_position = evaluate_script("$('.md-input-upload').css('position')")

    execute_script("$('.md-input-upload').css('position', 'initial')")

    find('.md-input-upload', visible: false).set(files)

    execute_script("$('.md-input-upload').css('position', '#{before_position}')")
  end
end

class UploadImagesTest < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = false

  include AdminTestHelper
  include MarkdownEditorUploadImageHelper

  setup do |&test|
    DatabaseCleaner.strategy = :truncation

    DatabaseCleaner.cleaning do
      login_as_admin

      test.call
    end

    DatabaseCleaner.strategy = DatabaseCleaner.default_strategy
  end

  attribute :js, true
  test 'Upload images' do
    click_on '記事'

    click_on 'New Post'

    upload_images(File.join(fixture_path, 'images/daimon.png'), File.join(fixture_path, 'images/daimon2.png'))

    assert find('.ace_content').has_content?('![](/uploads/image/image/1/daimon.png) ![](/uploads/image/image/2/daimon2.png)')
  end
end
