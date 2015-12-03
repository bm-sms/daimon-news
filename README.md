# daimon-news-multi-tenant

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
