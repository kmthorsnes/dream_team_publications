require 'coveralls'
Coveralls.wear_merged!('rails')

require 'cucumber/rails'

World(FactoryBot::Syntax::Methods)
World(Warden::Test::Helpers)

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.clean_with :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Warden.test_mode!
After { Warden.test_reset! }

Chromedriver.set_version '2.36'

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
      implicit_wait: 60,
      args: %w(headless disable-popup-blocking disable-infobars),
  )

  Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options
  )
end
Capybara.javascript_driver = :selenium
