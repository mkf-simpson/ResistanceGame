started = false
lastX = null
Template.roomList.events
  'click .js-add-room': ->
    nameEl = document.querySelector('.js-add-room-input')
    Rooms.insert
      name: if nameEl.value then nameEl.value else 'Noname'
      creation_date: new Date()
      creator:
        id: Meteor.user()._id
        name: Meteor.user().profile.name
    , (err, id) ->
      if !err
        RoomUsers.insert
          room: id
          player:
            id: Meteor.user()._id
            name: Meteor.user().profile.name
            creator: yes
            accepted: yes
          creation_date: new Date()

    nameEl.value = ''

  'click .js-table-cell': (event) ->
    $target = $ event.currentTarget
    Router.go "/room/#{$target.attr 'data-id'}"


  'touchstart .js-table-cell': (event) ->
    lastX = event.originalEvent.touches[0]?.clientX
    started = true

  'touchend .js-table-cell': (event) ->
    lastX = null
    started = false
    $target = $ event.currentTarget

    currentWidth = $target.width()
    id = $target.attr 'data-id'
    room = Rooms.findOne _id: id

    if -$target.position().left > currentWidth / 2 and room.creator.id is Meteor.user()._id
      $target.animate left: '-100%',
        duration: 'fast'
        complete: -> Rooms.remove id
    else
      $target.animate left: 0,
        duration: 'slow'
        easing: 'easeOutBounce'


  'touchmove .js-table-cell': (event) ->
    if started and lastX?
      $target = $ event.currentTarget
      currentLeft = $target.position().left
      currentX = event.originalEvent.touches[0]?.clientX
      delta = lastX - currentX

      newLeft = Math.min currentLeft - delta, 0
      if newLeft <= 0
        $target.css 'left', newLeft

      lastX = currentX

Template.roomList.rendered = ->
#  setTimeout ->
#    $('.notification').addClass 'opened'
#  , 1000

Template.roomList.roomCount = ->
  @rooms?.count()