Rails.application.routes.draw do
  root 'admin/root#index'

  namespace :admin do
    root 'root#index'

    resources :sites
    resources :posts
  end

  resources :sites do
    resources :posts, only: %i(index show), controller: :site_posts
  end
  match 'home', via: :get, controller: :site_posts, action: :index
end
