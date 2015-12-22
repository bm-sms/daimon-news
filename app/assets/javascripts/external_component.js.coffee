#= require jquery

jq = $.noConflict(true)

jq ->
  jq('.external-component').each ->
    jq.ajax(
      type: 'GET'
      url: jq(@).data('external-src')
      xhrFields:
        withCredentials: true
    ).then (html) =>
      jq(@).replaceWith(html)

    true
