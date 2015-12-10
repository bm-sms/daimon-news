Rails.application.routes.draw do
  root 'posts#index'

  namespace :admin do
    root 'root#index'

    resources :sites
    resources :posts
    resources :categories
  end

  concern :site do
    resources :posts, only: %i(index show)
    resources :categories, only: %i(show), path: 'category'
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end
end
