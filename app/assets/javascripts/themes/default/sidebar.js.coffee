$(document)
  .on 'click', '[data-sidebar]', ->
    target = $(@).data('sidebar')
    $(".sidebar--#{target}").modal('show')

  .on 'click', '[data-modal-state=visible] + .backdrop', ->
    $(@).prev().modal('hide')
