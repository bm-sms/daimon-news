module CustomCssSupport
  extend ActiveSupport::Concern

  included do
    validates :base_hue, numericality: {
      greater_than_or_equal_to: 0,
      less_than: 360,
      allow_nil: true
    }

    before_save :update_custom_css, if: :base_hue_changed?
  end

  private

  def update_custom_css
    if base_hue.present?
      asset = generate_custom_css

      file = Tempfile.open(["", "-custom-#{asset.digest}.css"])
      file.write(asset.to_s)

      self.custom_hue_css = file
    else
      self.remove_custom_hue_css = true
    end
  end

  def generate_custom_css
    with_tmp_dir(Rails.root.join("tmp/custom_css")) do |dir|
      assets = Rails.application.assets

      site_path = Pathname(dir).join("custom")
      original_css_path = assets.resolve("themes/default/application.css")

      FileUtils.cp_r(Pathname(original_css_path).join("../"), site_path)

      overwrite_variables(site_path) do |variables|
        variables.gsub(/^(\$base-hue: *)\d+(.+)$/, "\\1 #{base_hue}\\2")
      end

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

  def overwrite_variables(site_path)
    variables_path = site_path.join("_variables.scss")

    variables_path.write(yield(variables_path.read))
  end
end
