module Daimon
  module Render
    class HTML < Redcarpet::Render::HTML
      def block_quote(quote)
        blockquotes = quote.each_line("").map do |paragraph|
            "\n<blockquote>\n#{paragraph.strip}\n</blockquote>"
        end
        "#{blockquotes.join("\n")}\n"
      end
    end
  end
end
