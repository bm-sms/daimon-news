# daimon-news
[![CircleCI](https://circleci.com/gh/bm-sms/daimon-news.svg?style=svg)](https://circleci.com/gh/bm-sms/daimon-news)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.txt)
[![Dependency Status](https://gemnasium.com/badges/github.com/bm-sms/daimon-news.svg)](https://gemnasium.com/github.com/bm-sms/daimon-news)

NOTE: The documentation is in progress.

## Requirements

* [Ruby](https://www.ruby-lang.org) … 2.3.3
* [bundler](http://bundler.io/)
* [Groonga](http://groonga.org/)
* [PostgreSQL](https://www.postgresql.org/) … ~> 9.5

If you use macOS and have not used groonga:

    $ brew install groonga --with-mecab

Requires postgresql and phantomjs too:

    $ brew install postgresql
    $ brew install phantomjs

## Setup

Install dependencies and setup database:

    $ bundle install
    $ bin/rake db:create db:structure:load

How to load dummy data for development:

    $ bin/rake db:seed:development
