source "https://rubygems.org"

ruby "2.3.1"

gem "rails", "~> 4.2.6"

gem "active_decorator"
gem "active_link_to"
gem "active_model_serializers"
gem "bootstrap-sass"
gem "bootstrap_form"
gem "bourbon"
gem "browser"
gem "carrierwave"
gem "cocoon"
gem "daimon-markdown"
gem "daimon_news-layout", github: "bm-sms/daimon_news-layout"
gem "devise", ">= 3.5.4"
gem "fog"
gem "font-awesome-sass"
gem "gretel"
gem "haml-rails"
gem "jquery-rails"
gem "kaminari"
gem "meta-tags", require: "meta_tags"
gem "pg"
gem "puma"
gem "rails-i18n"
gem "rambulance"
gem "redcarpet"
gem "rouge"
gem "rroonga"
gem "sass-rails"
gem "seedbank"
gem "select2-rails"
gem "sitemap_generator"
gem "sprockets-es6"
gem "uglifier"

source "https://rails-assets.org" do
  gem "rails-assets-bootstrap-markdown-editor"
  gem "rails-assets-marked"
  gem "rails-assets-spectrum"
end

group :development, :test do
  gem "factory_girl"
  gem "pry-byebug"
end

group :development do
  gem "launchy"
  gem "pry-rails"
  gem "rails-erd", require: false
  gem "rubocop", require: false
  gem "web-console", "~> 2.0"
end

group :test do
  gem "database_cleaner"
  gem "poltergeist"
  gem "test-unit-rails", require: false
end

group :production do
  gem "airbrake"
  gem "newrelic_rpm"
  gem "rack-contrib", require: "rack/contrib"
  gem "rack-cors"
  gem "rack-timeout"
  gem "rails_12factor"
end
