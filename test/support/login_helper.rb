module LoginHelper
  def login_as_admin(site:, admin:)
    switch_domain(site.fqdn)

    visit "/admin"

    fill_in "Email",    with: admin.email
    fill_in "Password", with: DEFAULT_PASSWORD
    click_on "Log in"
  end

  def login_as_editor(site:, editor:)
    switch_domain(site.fqdn)

    visit "/editor"

    fill_in "Email",    with: editor.email
    fill_in "Password", with: DEFAULT_PASSWORD
    click_on "Log in"
  end
end

ActionDispatch::IntegrationTest.include(LoginHelper)
