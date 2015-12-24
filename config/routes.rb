Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root 'welcome#index'

  namespace :api do
    resources :sites, only: :update
  end

  concern :site do
    resources :posts, only: %i(show), param: :original_id
    resources :categories, only: %i(show), path: 'category'

    resources :topics, only: %i(index new show create)
    resources :comments, only: :create

    resource :feed, only: %i(show), path: 'feed', controller: 'feed'

    resource :sitemaps, only: %i(show), path: 'sitemap'

    resources :hooks, only: [], param: :token do
      member do
        post :trigger, path: '/'
      end
    end
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end
end
