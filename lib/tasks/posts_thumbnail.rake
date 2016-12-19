namespace :posts_thumbnail do
  desc "creates resized thumbnails of posts"

  task :generate_resized => :environment do
    Post.all.each do |post|
      post.thumbnail.recreate_versions! if post.thumbnail.present?
    end
  end
end
