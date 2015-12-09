Rails.application.routes.draw do
  root 'posts#index'

  namespace :admin do
    root 'root#index'

    resources :sites
    resources :posts
    resources :categories
  end

  resources :posts, only: %i(index show)

  # for debug
  resources :sites do
    resources :posts, only: %i(index show)
  end
end
