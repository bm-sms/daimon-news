Rails.application.routes.draw do
  root 'site_posts#index'

  namespace :admin do
    root 'root#index'

    resources :sites
    resources :posts
    resources :categories
  end

  resources :sites do
    resources :posts, only: %i(index show), controller: :site_posts
  end
end
