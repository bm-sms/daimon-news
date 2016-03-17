//= require ace-builds/src/ace
//= require ace-builds/src/theme-tomorrow
//= require ace-builds/src/mode-markdown
//= require ace-builds/src/ext-language_tools
//= require bootstrap-markdown-editor
//= require marked

$(function() {
  function embedMarkdownEditor(selector) {
    let $postBody = $(selector);

    if ($postBody.length === 0) {
      return;
    }

    let content = $postBody.val();
    let $editor = $('<div id="editor"></div>');

    $postBody.hide();
    $postBody.after($editor);

    $editor.markdownEditor({
      preview: true,
      imageUpload: true,
      uploadPath:  $postBody.data('upload-path'),
      onPreview(content, callback) {
        callback(marked(content));
      }
    });
    $editor.markdownEditor('setContent', content);
    $('form').submit((event) => {
      let content = $editor.markdownEditor('content');

      $postBody.val(content);
    });
  }
  embedMarkdownEditor('#post_body');
  embedMarkdownEditor('#fixed_page_body');
});

// FormData.get polyfill
{
  let originalFormData = FormData;
  let originalAppend = FormData.prototype.append;

  FormData.prototype.append = function(...args) {
    this.data[args[0]] = args.slice(1);
    return originalAppend.call(this, ...args);
  }
  FormData.prototype.get = function(name) {
    return this.data[name];
  }
  window.FormData = function() {
    let fd = new originalFormData();
    fd.data = {};

    return fd;
  }
}

// Workaround to avoid empty content POST request
// https://github.com/inacho/bootstrap-markdown-editor/pull/16
$(document).on('ajaxSend', (event, xhr, opts) => {
  if (!opts.data.get('file0')) { xhr.abort(); }
});
