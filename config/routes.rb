Rails.application.routes.draw do
  devise_for :users

  root 'welcome#index'

  namespace :admin do
    root 'welcome#index'

    resources :sites, except: :destroy do
      resource :editors, only: %i(edit update), controller: :site_editors
    end
    resources :users, except: :show
  end

  namespace :editor do
    root 'welcome#index'

    resources :fixed_pages
    resources :links
    resources :categories
    resources :posts do
      member do
        get :preview
      end
    end
    resources :images, only: :create
    resources :participants
  end

  concern :site do
    get 'search', controller: 'search'

    resources :posts, only: %i(show), constraints: {id: /\d+/}, path: '/'
    resources :categories, only: %i(show), path: 'category'

    # compatibility for old URL
    get ':id/:page' => redirect('%{id}?page=%{page}'), constraints: {id: /\d+/, page: /\d+/}
    get 'category/:slug/page/:page' => redirect('category/%{slug}?page=%{page}')

    resource :feed, only: %i(show), path: 'feed', controller: 'feed'

    resource :sitemaps, only: %i(show), path: 'sitemap'

    resource :robots, only: %i(show), path: 'robots'

    resources :fixed_pages, param: :slug, path: '/', only: :show
  end

  concerns :site

  # for debug
  resources :sites, only: %i() do
    concerns :site
  end if Rails.env.development?
end
