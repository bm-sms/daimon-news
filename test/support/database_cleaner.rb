def DatabaseCleaner.default_strategy
  :transaction
end

DatabaseCleaner.strategy = DatabaseCleaner.default_strategy
DatabaseCleaner.clean_with :truncation

module DatabaseCleanerHelper
  extend ActiveSupport::Concern

  included do
    setup before: :prepend
    def setup_database_cleaner(&test)
      if self[:js]
        DatabaseCleaner.strategy = :truncation

        DatabaseCleaner.cleaning do
          test.call
        end

        DatabaseCleaner.strategy = DatabaseCleaner.default_strategy
      else
        DatabaseCleaner.cleaning do
          test.call
        end
      end
    end
  end
end

ActiveSupport::TestCase.include(DatabaseCleanerHelper)
ActionDispatch::IntegrationTest.include(DatabaseCleanerHelper)
