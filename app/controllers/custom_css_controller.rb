class CustomCssController < ApplicationController
  def show
    # TODO: `Site#base_hue` が未設定の場合は、デフォルトの URL にリダイレクトする

    render text: generate_custom_css(current_site), content_type: "text/css"
  end

  private

  def generate_custom_css(site)
    with_tmp_dir(Rails.root.join("tmp/custom_css")) do |dir|
      assets = Rails.application.assets

      # TODO: このあたりは layout gem に public API を用意したい

      site_path = Pathname(dir).join("custom")
      original_css_path = assets.resolve("themes/default/application.css")

      FileUtils.cp_r(Pathname(original_css_path).join("../"), site_path)

      variables_path = site_path.join("_variables.scss")
      variables = variables_path.read
      variables_path.write variables.gsub(/^(\$base-hue: *)\d+(.+)$/, "\\1 #{site.base_hue}\\2")

      assets[site_path.join("application.scss")]
    end
  end

  def with_tmp_dir(tmp_dir)
    FileUtils.mkdir_p(tmp_dir)

    result = nil

    Dir.mktmpdir(nil, tmp_dir) do |dir|
      result = yield(dir)
    end

    result
  end
end
