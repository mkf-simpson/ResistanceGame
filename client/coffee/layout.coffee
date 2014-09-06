toggleFullScreen = ->
  if not document.fullscreenElement? and not document.mozFullScreenElement? and not document.webkitFullscreenElement?
    if document.documentElement.requestFullscreen?
      document.documentElement.requestFullscreen()
    else if document.documentElement.mozRequestFullScreen?
      document.documentElement.mozRequestFullScreen()
    else if document.documentElement.webkitRequestFullscreen?
      document.documentElement.webkitRequestFullscreen Element.ALLOW_KEYBOARD_INPUT
    return 'open'
  else
    if document.cancelFullScreen?
      document.cancelFullScreen()
    else if document.mozCancelFullScreen?
      document.mozCancelFullScreen()
    else if document.webkitCancelFullScreen?
      document.webkitCancelFullScreen()
    return 'close'



Template.layout.events
  'click .js-logout': ->
    Router.go 'logout'
  'click .js-back': ->
    Template.layout.backAction?()

Template.layout.rendered = ->
  started = false
  lastY = null
  startY = null
  $(document).on 'touchstart', '.js-footer', (event) ->
    started = true
    startY = lastY = event.originalEvent.touches[0].clientY

  $(document).on 'touchend', '.js-footer', (event) ->
    if started
      started = false
      console.log lastY, startY, $('body').height() * 0.1
      if startY - lastY >= $('body').height() * 0.1
        $(event.currentTarget).find('.js-notification').addClass('opened')
      lastY = null

  $(document).on 'touchmove', '.js-footer', (event) ->
    if started and lastY?
      lastY = event.originalEvent.touches[0].clientY

  $(document).on 'click', '.js-close-notification', (event) ->

    $(event.currentTarget).closest('.js-notification').removeClass 'opened'

  $(document).on 'click', '.js-fullscreen', (event) ->
    result = toggleFullScreen()
    $(event.currentTarget).text(if result is 'open' then 'exit fullscreen' else 'fullscreen mode').closest('.js-notification').removeClass 'opened'

Template.layout.hiddenBack = (hidden = false) ->
  if hidden isnt true
    $('.js-back').removeClass('hidden')
  else
    $('.js-back').addClass('hidden')
