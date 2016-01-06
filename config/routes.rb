Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  root 'welcome#index'

  concern :site do
    resources :posts, only: %i(show), param: :original_id, constraints: {original_id: /\d+/}, path: '/'
    get '/:original_id/:page' => redirect('/%{original_id}?page=%{page}'), constraints: {original_id: /\d+/, page: /\d+/} # To compatible with old URL
    resources :categories, only: %i(show), path: 'category'

    resource :feed, only: %i(show), path: 'feed', controller: 'feed'

    resource :sitemaps, only: %i(show), path: 'sitemap'
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end if Rails.env.development?
end
