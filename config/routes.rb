Rails.application.routes.draw do
  devise_for :users

  root 'welcome#index'

  namespace :admin do
    root 'welcome#index'
  end

  concern :site do
    resources :posts, only: %i(show), constraints: {id: /\d+/}, path: '/'
    resources :categories, only: %i(show), path: 'category'

    resource :feed, only: %i(show), path: 'feed', controller: 'feed'

    resource :sitemaps, only: %i(show), path: 'sitemap'

    resources :fixed_pages, param: :slug, path: '/', only: :show
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end if Rails.env.development?
end
