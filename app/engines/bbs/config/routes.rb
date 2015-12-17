Bbs::Engine.routes.draw do
  resources :topics, only: %i(index new show create)
  resources :comments, only: :create
end
