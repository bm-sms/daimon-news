Rails.application.routes.draw do
  root 'posts#index'

  concern :site do
    resources :posts, only: %i(index show)
    resources :categories, only: %i(show), path: 'category'
  end

  concerns :site

  # for debug
  resources :sites do
    concerns :site
  end
end
