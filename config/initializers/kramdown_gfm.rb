require "kramdown"

module Kramdown
  module Parser
    class Kramdown
      AUTOLINK_RAW_START_STR = "((mailto|https?|ftps?):.+?|[-.#{ACHARS}]+@[-#{ACHARS}]+(?:\.[-#{ACHARS}]+)*\.[a-z]+)"
      AUTOLINK_RAW_START = /\A#{AUTOLINK_RAW_START_STR}\z/u

      define_parser(:autolink_raw, AUTOLINK_RAW_START, nil, "parse_autolink")
    end
  end
end

module AutolinkRaw
  def initialize(source, options)
    super
    @span_parsers.push(:autolink_raw)
  end
end

Kramdown::Parser::GFM.prepend(AutolinkRaw)
