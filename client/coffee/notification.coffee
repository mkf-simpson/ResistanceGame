@notification =
  show: (text) ->
    $('.global-notification').text(text).animate {
      top: 0
    }, 'slow', ->
      setTimeout ->
        $('.global-notification').animate({top: '-44px'}, 'slow')
      , 5 * 1000