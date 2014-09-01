Template.roomList.events
  'click .js-add-room': ->
    nameEl = document.querySelector('.js-add-room-input')
    Rooms.insert
      name: nameEl.value
      creation_date: new Date()
      creator:
        name: Meteor.user().profile.login

    nameEl.value = ''

Template.roomList.rendered = ->