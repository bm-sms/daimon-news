Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root 'welcome#index'

  namespace :api do
    resources :sites, only: :update
  end

  concern :site do
    resources :posts, only: %i(show)
    resources :categories, only: %i(show), path: 'category'

    resources :topics, only: %i(index new show create)
    resources :comments, only: :create

    resource :sitemaps, only: %i(show), path: 'sitemap'

    resources :fixed_pages, only: :show, path: '/'
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end
end
