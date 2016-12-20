module DomainHelper
  extend ActiveSupport::Concern

  DEFAULT_HOST = "http://www.example.com".freeze

  included do
    setup before: :prepend
    def setup_capybara_default_host
      Capybara.default_host = DEFAULT_HOST
    end
  end

  def switch_domain(domain)
    Capybara.default_host = "http://" + domain
  end
end

ActionDispatch::IntegrationTest.include(DomainHelper)

Capybara.add_selector(:row) do
  xpath {|text| "//tr[./td[normalize-space(.) = '#{text}']]" }
end

Capybara.add_selector(:form_group) do
  xpath {|label| "//*[@class='form-group' and .//label[text()='#{label}']]" }
end
