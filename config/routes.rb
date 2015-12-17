Rails.application.routes.draw do
  resources :topics
  resources :comments
  ActiveAdmin.routes(self)
  root 'posts#index'

  namespace :api do
    resources :sites, only: :update
  end

  concern :site do
    resources :posts, only: %i(show)
    resources :categories, only: %i(show), path: 'category'
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end

  resources :fixed_pages, only: :show, path: '/'
end
