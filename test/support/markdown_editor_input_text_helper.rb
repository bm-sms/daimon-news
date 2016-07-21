module MarkdownEditorInputTextHelper
  def fill_in_markdown_editor(text)
    find_markdown_editor_field.set(text)
  end

  def find_markdown_editor_field
    find(".ace_text-input", visible: false)
  end
end

ActionDispatch::IntegrationTest.include(MarkdownEditorInputTextHelper)
