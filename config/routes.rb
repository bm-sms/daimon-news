Rails.application.routes.draw do
  devise_for :users

  root 'welcome#index'

  namespace :admin do
    root 'welcome#index'

    resources :sites, except: :destroy
    resources :users, except: :show
    resources :authors
  end

  namespace :editor do
    root 'welcome#index'

    resources :fixed_pages
    resources :links
    resources :categories
    resources :posts
    resources :images, only: :create
  end

  concern :site do
    resources :posts, only: %i(show), constraints: {id: /\d+/}, path: '/'
    resources :categories, only: %i(show), path: 'category'

    resource :feed, only: %i(show), path: 'feed', controller: 'feed'

    resource :sitemaps, only: %i(show), path: 'sitemap'

    resource :robots, only: %i(show), path: 'robots'

    resources :fixed_pages, param: :slug, path: '/', only: :show
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end if Rails.env.development?
end
