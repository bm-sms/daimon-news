class HooksController < ApplicationController
  protect_from_forgery with: :null_session

  def trigger
    current_site.hooks.find_by!(token: params[:token])

    *, category_name, title = params[:post][:name].split('/')
    category = current_site.categories.find_by!(name: category_name)
    body = params[:post][:body_md]
    source_url = params[:post][:url]

    case params[:kind]
    when 'post_create'
      current_site.posts.create!(
        category:   category,
        title:      title,
        body:       body,
        source_url: source_url
      )
    when 'post_update'
      current_site.posts.find_or_initialize_by(source_url: source_url).update!(
        category: category,
        title:    title,
        body:     body
      )
    end

    head :ok
  end
end
