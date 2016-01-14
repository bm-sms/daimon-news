class CustomCssController < ApplicationController
  def show
    render text: generate_custom_css(current_site), content_type: 'text/css'
  end

  private

  def generate_custom_css(site)
    asset = nil

    Dir.mktmpdir(nil, Rails.root.join('tmp/custom_css')) do |dir|
      site_path = Pathname(dir).join('custom')

      FileUtils.cp_r Rails.root.join('app/assets/stylesheets/themes/default'), site_path

      variables_path = site_path.join('_variables.sass')
      variables = variables_path.read
      variables_path.write variables.gsub(/^(\$base-color:).+$/, "\\1 #{site.base_color}")

      asset = Rails.application.assets[site_path.join('application.sass')]
    end

    asset
  end
end
