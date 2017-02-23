module DaimonMarkdown
  class Plugin
    class TableOfContentsPages < Base
      Plugin.register("toc_pages", self)

      include MarkdownHelper

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/PerceivedComplexity
      def call(limit = nil)
        return unless context.key?(:original_text)

        original_text = context[:original_text]
        fullpath = context[:fullpath]
        current_page =
          if context.key?(:current_page)
            context[:current_page].to_i
          else
            1
          end

        html = Nokogiri::HTML(render_markdown(original_text))

        toc_html = ""
        items = []

        headers = Hash.new(0)
        previous_level = 1
        page = 1
        page_separated_nodes = []
        condition = 1.upto(6).map {|n| "./following::h#{n}" }.join("|")
        html.search("//comment()[contains(.,\"nextpage\")]").map do |comment_element|
          page_separated_nodes << comment_element.search(condition).first
        end

        headers_per_page = Hash.new {|h, k| h[k] = [] }
        # rubocop:disable Metrics/BlockLength
        html.css("h1, h2, h3, h4, h5, h6").each do |header_node|
          page += 1 if page_separated_nodes.include?(header_node)
          headers_per_page[page] << header_node
          level = header_node.name.tr("h", "").to_i
          next if limit && limit < level
          text = header_node.text
          id = text.downcase
          id.tr!(/ /, "-")
          id.gsub!(/\s/, "")

          unique_id =
            if headers[id] > 0
              "#{id}-#{headers[id]}"
            else
              id
            end
          headers[id] += 1
          header_content = header_node.children.first
          # TODO: Arrange indent level
          if header_content
            diff = level - previous_level
            case
            when diff > 0
              items.concat(["<ul>"] * diff)
            when diff < 0
              items.concat(["</ul>"] * diff.abs)
            end
            items <<
              if page == 1
                list_item(link_to("##{unique_id}", text))
              else
                list_item(link_to("#{fullpath}?page=#{page}##{unique_id}", text))
              end
            header_node["id"] = unique_id
          end
          previous_level = level
        end

        current_header_nodes = doc.css("h1, h2, h3, h4, h5, h6")
        current_header_nodes.zip(headers_per_page[current_page]) do |target_node, replaced_node|
          target_node["id"] = replaced_node["id"]
        end

        toc_class = context[:toc_class] || "section-nav"
        toc_header = context[:toc_header] || ""
        unless items.empty?
          toc_html = %Q(#{toc_header}<ul class="#{toc_class}">\n#{items.join("\n")}\n</ul>)
        end

        if current_page == 1
          node.parent.replace(toc_html)
        else
          node.parent.replace("")
        end
      end

      private

      def link_to(href, text)
        %Q(<a href="#{href}">#{text}</a>)
      end

      def list_item(content)
        %Q(<li>#{content}</li>)
      end
    end
  end
end
