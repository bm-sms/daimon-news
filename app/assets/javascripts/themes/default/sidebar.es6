$(document)
  .on('click', '[data-sidebar]', (e) => {
    let target = $(e.target).data('sidebar');

    $(`.sidebar--${target}`).modal('show');
  })

  .on('click', '[data-modal-state=visible] + .backdrop', (e) => {
    $(e.target).prev().modal('hide');
  });
