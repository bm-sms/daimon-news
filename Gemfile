source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.3.3"

gem "rails", "~> 4.2.6"

gem "active_decorator"
gem "active_link_to"
gem "active_model_serializers"
gem "addressable"
gem "ancestry"
gem "bootstrap-sass"
gem "bootstrap_form"
gem "bourbon"
gem "browser"
gem "carrierwave"
gem "cocoon", github: "mtsmfm/cocoon", branch: "fix-on-ready-for-jquery-3" # cocoon doesn't work well with jQuery 3 (https://github.com/nathanvda/cocoon/pull/379)
gem "daimon_markdown"
gem "daimon_news-layout", github: "bm-sms/daimon_news-layout"
gem "devise", ">= 3.5.4"
gem "fog"
gem "font-awesome-sass"
gem "google-api-client", "~> 0.9"
gem "gretel"
gem "haml-rails"
gem "kaminari"
gem "meta-tags", require: "meta_tags"
gem "order_as_specified"
gem "pg"
gem "puma"
gem "rails-i18n"
gem "rambulance"
gem "ransack"
gem "redcarpet"
gem "rouge"
gem "rroonga"
gem "sass-rails"
gem "seedbank"
gem "select2-rails"
gem "simpleidn"
gem "sitemap_generator"
gem "sprockets-es6"
gem "uglifier"

source "https://rails-assets.org" do
  gem "rails-assets-bootstrap-markdown-editor-mtsmfm-fork" # To use new ace-builds
  gem "rails-assets-jquery"
  gem "rails-assets-jquery-ujs"
  gem "rails-assets-marked"
  gem "rails-assets-spectrum"
end

group :development, :test do
  gem "factory_girl"
  gem "pry-byebug"
end

group :development do
  gem "active_record_query_trace"
  gem "bullet"
  gem "launchy"
  gem "pry-doc"
  gem "pry-rails"
  gem "rails-erd", require: false
  gem "rubocop", require: false
  gem "web-console", "~> 2.0"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "poltergeist"
  gem "test-unit-rails", require: false
end

group :production do
  gem "airbrake"
  gem "heroku-deflater"
  gem "newrelic_rpm"
  gem "rack-contrib", require: "rack/contrib"
  gem "rack-cors"
  gem "rack-timeout"
  gem "rails_12factor"
  gem "redis-rails"
end
