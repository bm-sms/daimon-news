//= require ace-builds/src/ace
//= require ace-builds/src/theme-tomorrow
//= require ace-builds/src/mode-markdown
//= require ace-builds/src/ext-language_tools
//= require bootstrap-markdown-editor


$(document).ready(function() {
    var content = $('#post_body').val();
    $('#post_body').hide();
    $('#post_body').after('<div id="editor"></div>');
    $('div#editor').markdownEditor({
        preview: false,
        imageUpload: false,
        width: '80%'
    });
    $('div#editor').markdownEditor('setContent', content);
    $('form#edit_post').submit(function(event) {
        var content = $('div#editor').markdownEditor('content');
        $('#post_body').val(content);
    });
});
