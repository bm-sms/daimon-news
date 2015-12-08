Rails.application.routes.draw do
  root 'welcome#index'

  resources :posts
  resources :sites do
    resources :posts, only: %i(index show), controller: :site_posts
  end
  match 'home', via: :get, controller: :site_posts, action: :index
end
