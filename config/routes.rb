Rails.application.routes.draw do
  root 'welcome#index'

  resources :posts
  resources :sites
end
