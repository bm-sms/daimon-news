DaimonNewsBlog::Engine.routes.draw do
  resources :sites do
    resources :posts, only: %i(index show), controller: :site_posts
  end
  match '/', via: :get, controller: :site_posts, action: :index
end
