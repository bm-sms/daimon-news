Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root 'posts#index'

  concern :site do
    resources :posts, only: %i(index show)
    resources :categories, only: %i(show), path: 'category'
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end

  resources :fixed_pages, only: :show, path: '/'
end
