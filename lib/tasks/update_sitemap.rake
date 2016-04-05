namespace :daimon do
  desc "Update sitemap.xml for all sites"
  task "update_all_sitemap" => :environment do
    Site.where(opened: true).pluck(:id).each do |id|
      task = "daimon:create_sitemap"

      Rake::Task[task].invoke(id.to_s)
      Rake::Task[task].reenable

      SitemapGenerator::Sitemap.ping_search_engines
    end
  end

  desc "Create sitemap.xml"
  task :create_sitemap, :site_id
  task :create_sitemap => :environment do |t, args|
    begin
      old, ENV["SITEMAP_SITE_ID"] = ENV["SITEMAP_SITE_ID"], args[:site_id]
      task = "sitemap:create"

      Rake::Task[task].invoke
      Rake::Task[task].reenable
    ensure
      ENV["SITEMAP_SITE_ID"] = old
    end
  end
end
