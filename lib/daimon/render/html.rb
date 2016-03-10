require "rouge/plugins/redcarpet"

module Daimon
  module Render
    class HTML < Redcarpet::Render::HTML
      include Rouge::Plugins::Redcarpet
    end
  end
end
