//= require ace-builds/src/ace
//= require ace-builds/src/theme-tomorrow
//= require ace-builds/src/mode-markdown
//= require ace-builds/src/ext-language_tools
//= require bootstrap-markdown-editor
//= require marked

$(function() {
  let content = $('#post_body').val();

  $('#post_body').hide();
  $('#post_body').after('<div id="editor"></div>');
  $('div#editor').markdownEditor({
    preview: true,
    imageUpload: false,
    width: 'calc(80% - 22px)',
    onPreview(content, callback) {
      callback(marked(content));
    }
  });
  $('div#editor').markdownEditor('setContent', content);
  $('form#edit_post').submit((event) => {
    let content = $('div#editor').markdownEditor('content');

    $('#post_body').val(content);
  });
});
