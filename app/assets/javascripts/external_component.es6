(($) => {
  $(() => {
    $('.external-component').each((e) => {
      let $el = $(e.target);

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
