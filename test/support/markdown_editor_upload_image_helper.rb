module MarkdownEditorUploadImageHelper
  def upload_images(*files)
    # XXX bootstrap-markdown-editor's upload button can't click by poltergeist because of its style.
    # The input tag is computed as big square but visible (clickable) area is very small
    # and poltergeist doesn't detect where can be clicked.
    before_position = evaluate_script("$('.md-input-upload').css('position')")

    execute_script("$('.md-input-upload').css('position', 'initial')")

    find(".md-input-upload", visible: false).set(files)

    execute_script("$('.md-input-upload').css('position', '#{before_position}')")
  end
end

ActionDispatch::IntegrationTest.include(MarkdownEditorUploadImageHelper)
