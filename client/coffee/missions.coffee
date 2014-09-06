@missionsView =
  show: ->
    $('.content').addClass 'blured'
    $('.mission-container').show()
    $('.mission-result-container').animate {top: '200px'}, {duration: 'slow', easing: 'easeOutBounce'}

  hide: ->
    $('.content').removeClass 'blured'
    $('.mission-result-container').animate {top: '-60px'}, {duration: 'slow', easing: 'easeInCirc', complete: -> $('.mission-container').hide()}

