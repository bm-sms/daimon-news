Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root 'welcome#index'

  namespace :api do
    resources :sites, only: :update
  end

  concern :site do
    resources :posts, only: %i(show), param: :original_id, constraints: {original_id: /\d+/}, path: '/'
    resources :categories, only: %i(show), path: 'category'

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
