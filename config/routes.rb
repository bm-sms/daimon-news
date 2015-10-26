Rails.application.routes.draw do
  root 'welcome#index'

  resources :posts
  resources :sites do
    resources :posts, only: %i(index), controller: :site_posts
  end
end
