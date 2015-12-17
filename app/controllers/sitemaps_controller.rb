class SitemapsController < ApplicationController
  def show
    respond_to do |format|
      # XXX Dup with `config/sitemap.rb`
      format.xml { redirect_to "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/sitemaps/#{current_site.id}/sitemap.xml.gz" }
    end
  end
end
