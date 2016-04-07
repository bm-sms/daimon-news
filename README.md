# daimon-news-multi-tenant

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Setup

``` sh
$ bin/setup
```

## Run server

``` sh
$ bin/rails s
```

## Routing

### Admin

http://localhost:3000/admin/

### Blog

http://localhost:3000/blog/sites/1/posts/

Or

http://site1.lvh.me:3000/blog/

## Starting up new service

1. Create new site in Admin route:
  * http://localhost:3000/admin/sites
2. Create posts in Admin route:
  * http://localhost:3000/admin/posts
3. You can show new service in Blog route:
  * http://localhost:3000/blog/sites/1/posts

## Customizing CSS/JavaScript

1. Create the following files:
  * public/site#{id}/site.css
  * public/site#{id}/site.js

### Confirming a site

```sh
$ bin/run-site SITE_ID
```

For example:

```sh
$ bin/run-site 1
```
