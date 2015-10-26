module PostDecorator
  include ActionView::Helpers::TagHelper

  def as_html
    content_tag 'article' do
      html_title = content_tag 'h2' do
        title
      end
      html_body = simple_format body

      [html_title, html_body].join.html_safe
    end
  end
end
