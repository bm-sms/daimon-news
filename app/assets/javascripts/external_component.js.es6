//= require jquery

(($) => {
  $(() => {
    $('.external-component').each((_, e) => {
      let $el = $(e);

      $.ajax({
        type: 'GET',
        url: $el.data('external-src'),
        xhrFields: {
          withCredentials: true
        }
      }).then((html) => $el.replaceWith(html));
    });
  })
})($.noConflict(true));
