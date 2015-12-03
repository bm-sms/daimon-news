Rails.application.routes.draw do
  #root 'welcome#index'
  mount DaimonNewsBlog::Engine => '/blog'
  mount DaimonNewsAdmin::Engine => '/admin'
end
