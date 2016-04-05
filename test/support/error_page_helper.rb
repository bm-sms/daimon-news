module ErrorPageHelper
  extend ActiveSupport::Concern

  included do
    setup before: :prepend
    def setup_error_page(&test)
      if self[:allow_rescue]
        Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = false
        Rails.application.env_config["action_dispatch.show_exceptions"] = true

        test.call

        Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = true
        Rails.application.env_config["action_dispatch.show_exceptions"] = false
      end
    end
  end
end

ActionDispatch::IntegrationTest.include(ErrorPageHelper)
