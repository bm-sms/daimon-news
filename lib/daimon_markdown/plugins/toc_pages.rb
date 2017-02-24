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
        toc_class = context[:toc_class] || "section-nav"

        page = 1
        condition = 1.upto(6).map {|n| "./following::h#{n}" }.join("|")
        page_separated_nodes = html.search("//comment()[contains(.,\"nextpage\")]").map do |comment_element|
          comment_element.at(condition)
        end

        headers_per_page = Hash.new {|h, k| h[k] = [] }
        ul_list = Hash.new {|h, k| h[k] = UnorderedList.new }
        ul_list[1] = UnorderedList.new(html_class: toc_class)
        previous_level = 1
        html.css("h1, h2, h3, h4, h5, h6").each do |header_node|
          page += 1 if page_separated_nodes.include?(header_node)
          headers_per_page[page] << header_node
          header = Header.new(node: header_node, fullpath: fullpath, page: page)
          next if limit && limit < header.level
          next unless header.content?
          header.unique_id = generate_unique_id(header.text)
          if header.level - previous_level > 0
            (previous_level + 1).upto(header.level) do |level|
              ul_list[level - 1] << ul_list[level]
            end
          end
          ul_list[header.level] << ListItem.new(header: header)
          previous_level = header.level
        end

        current_header_nodes = doc.css("h1, h2, h3, h4, h5, h6")
        current_header_nodes.zip(headers_per_page[current_page]) do |target_node, replaced_node|
          target_node["id"] = replaced_node["id"]
        end

        unless ul_list[1].items.empty?
          toc_header = context[:toc_header] || ""
          toc_html = "#{toc_header}#{ul_list[1].to_html}"
        end

        if current_page == 1
          node.parent.replace(toc_html)
        else
          node.parent.replace("")
        end
      end

      private

      def generate_unique_id(text)
        @headers ||= Hash.new(0)
        id = text.downcase
        id.tr!(" ", "-")
        id.gsub!(/\s/, "")

        unique_id =
          if @headers[id] > 0
            "#{id}-#{@headers[id]}"
          else
            id
          end
        @headers[id] += 1
        unique_id
      end

      class EmptyHeader
        def link
          ""
        end
      end

      class Header
        attr_reader :level, :text, :unique_id

        def initialize(node:, fullpath:, page:)
          @node = node
          @level = node.name.tr("h", "").to_i
          @text = node.text
          @fullpath = fullpath
          @page = page
          @unique_id = ""
        end

        def unique_id=(id)
          @node["id"] = id
          @unique_id = id
        end

        def content?
          @node.children.first
        end

        def link
          if @page == 1
            %Q(<a href="##{unique_id}">#{text}</a>)
          else
            %Q(<a href="#{@fullpath}?page=#{@page}##{unique_id}">#{text}</a>)
          end
        end
      end

      class UnorderedList
        attr_reader :items

        def initialize(html_class: nil)
          @html_class = html_class
          @items = []
        end

        def <<(item)
          case
          when item.is_a?(UnorderedList) && @items.last.is_a?(ListItem)
            @items.last << item
          when item.is_a?(UnorderedList) && @items.last.nil?
            li = ListItem.new
            li << item
            @items << li
          else
            @items << item
          end
        end

        def to_html
          if @html_class
            %Q(<ul class="#{@html_class}">\n#{@items.map(&:to_html).join("\n")}\n</ul>)
          else
            %Q(<ul>\n#{@items.map(&:to_html).join("\n")}\n</ul>)
          end
        end
      end

      class ListItem
        attr_reader :items

        def initialize(header: EmptyHeader.new)
          @header = header
          @items = []
        end

        def <<(item)
          @items << item
        end

        def to_html
          if @items.empty?
            "<li>#{@header.link}</li>"
          else
            %Q(<li>#{@header.link}\n#{@items.map(&:to_html).join("\n")}\n</li>)
          end
        end
      end
    end
  end
end
