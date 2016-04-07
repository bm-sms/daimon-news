# daimon-news-multi-tenant

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

A web application that can launch a news website easily and quickly. And it can manage multiple websites in a single web application.

Daimon is a place name. It's located in Hamamatsu-cho, Minato-ku, Tokyo, Japan.

## Setup

``` sh
$ bin/setup
```

Report to [GitHub Issues](https://github.com/bm-sms/daimon-news-multi-tenant/issues) if you get an error.

## Run server

``` sh
$ bin/rails s
```

## Usage

### Register administrators and editors

Register admin users and editor users via Rails console or seed data.

ref: [db/seeds/development/users.seeds.rb](https://github.com/bm-sms/daimon-news-multi-tenant/blob/master/db/seeds/development/users.seeds.rb)

### Manage sites information

http://localhost:3000/admin

Login as an admin user.

### Edit posts of a site

http://#{site.fqdn}/editor

Login as an editor user of the site.

### Show a site

http://#{site.fqdn}/

If the site is not opened, must be logged in to view posts. You can open the site in admin page.
