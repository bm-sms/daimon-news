do ($ = jQuery) ->
  actions =
    show: ($this) ->
      if $this.next('.backdrop').length == 0
        $backdrop = $('<a href="javascript:void(0);" class="backdrop"></a>')
        $this.after $backdrop
        $backdrop.on 'click', ->
          actions.hide $this

      $this.attr 'data-modal-state', 'visible'
      $('.root-container').attr 'data-layer', 'under-dialog'

    hide: ($this) ->
      $this.attr 'data-modal-state', 'hidden'
      $('.root-container').attr 'data-layer', 'top'

  $.fn.modal = (action) ->
    actions[action] @
    @
