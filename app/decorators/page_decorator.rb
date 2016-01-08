module PageDecorator
  def markdown_body
    @markdown_body ||= ReverseMarkdown.convert(body).gsub("\r", "\n")
  end
end
