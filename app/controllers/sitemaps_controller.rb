class SitemapsController < ApplicationController
  before_action :setup_site

  def show
    respond_to do |format|
      # XXX Dup with `config/sitemap.rb`
      format.xml { redirect_to "https://#{CarrierWave::Uploader::Base.fog_directory}.s3.amazonaws.com/sitemaps/#{@site.id}/sitemap.xml.gz" }
    end
  end
end
