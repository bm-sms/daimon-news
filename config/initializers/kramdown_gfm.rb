require "kramdown"

module Kramdown
  module Parser
    class Kramdown
      AUTOLINK_RAW_START = /(?:((mailto|https?|ftps?):[^ \n]+|[-.#{ACHARS}]+@[-#{ACHARS}]+(?:\.[-#{ACHARS}]+)*\.[a-z]+))/

      define_parser(:autolink_raw, AUTOLINK_RAW_START, nil, "parse_autolink")
    end
  end
end

module AutolinkRaw
  def initialize(source, options)
    super
    @span_parsers.push(:autolink_raw) if options[:autolink_raw]
  end
end

Kramdown::Parser::GFM.prepend(AutolinkRaw)
