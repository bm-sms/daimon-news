require 'motorhead/engine'

module Bbs
  class Engine < ::Rails::Engine
    include Motorhead::Engine

    active_if { false }
  end
end
