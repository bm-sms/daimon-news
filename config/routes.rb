Rails.application.routes.draw do
  devise_for :users

  root "welcome#index"

  namespace :admin do
    root "welcome#index"

    resources :sites, except: :destroy do
      resource :editors, only: %i(edit update), controller: :site_editors
    end
    resources :users, except: :show
  end

  namespace :editor do
    root "welcome#index"

    resources :posts, param: :public_id do
      get :preview, on: :member
    end
    resources :serials
    resources :images, only: :create
    resources :fixed_pages
    resources :links
    resources :categories do
      resource :order, module: :categories, only: %i(update)
    end
    resources :redirect_rules, except: %i(show)
    resources :pickup_posts, except: %i(show) do
      resource :order, module: :pickup_posts, only: %i(update)
    end
    resources :top_fixed_posts, except: %i(show) do
      resource :order, module: :top_fixed_posts, only: %i(update)
    end
    resources :participants
    resources :credit_roles
  end

  get "search", controller: "search"

  resources :posts, only: %i(show), param: :public_id, constraints: {public_id: /\d+/}, path: "/"
  resources :categories, only: %i(show), path: "category", param: :slug
  resources :serials, only: %i(index show)
  resources :participants, only: %i(index show)

  # compatibility for old URL
  get ":id/:page" => redirect("%{id}?page=%{page}"), constraints: {id: /\d+/, page: /\d+/}
  get "category/:slug/page/:page" => redirect("category/%{slug}?page=%{page}")

  resource :feed, only: %i(show), path: "feed", controller: "feed"
  resource :sitemaps, only: %i(show), path: "sitemap"
  resource :robots, only: %i(show), path: "robots"

  resources :fixed_pages, param: :slug, path: "/", only: :show

  resource :partial, only: %i() do
    get :pickup_posts
    get :popular_posts
  end

  namespace :api do
    resources :sites, only: %i(), path: "/", param: :fqdn, fqdn: %r{[^/]+} do
      resources :posts, only: %i(index show), param: :public_id
      resources :top_fixed_posts, only: %i(index)
    end
  end
end
