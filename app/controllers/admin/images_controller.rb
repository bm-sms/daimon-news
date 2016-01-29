class Admin::ImagesController < Admin::ApplicationController
  def create
    # NOTE bootstrap-markdown-editor がファイルごとにユニークなキーで画像を送信してくる
    images = params.select {|key, _| key =~ /\Afile\d+\z/ }.map do |_, image|
      current_site.images.create!(image: image)
    end

    render json: images.map(&:image_url)
  end
end
