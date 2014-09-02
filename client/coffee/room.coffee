Template.room.rendered = ->


Template.room.isMyRoom = ->
  @room.creator.id is Meteor.user()._id

Template.room.roomUserCount = ->
  @roomUsers.count()

Template.room.events
  'click .js-join-game': (event, template) ->
    RoomUsers.insert
      room: template.data.room._id
      player:
        id: Meteor.user()._id
        name: Meteor.user().profile.name
        creator: no
        accepted: no
      creation_date: new Date()

  'click .js-table-cell': (event, template) ->
    if template.data.room.creator.id is Meteor.user()._id
      $target = $(event.currentTarget)
      $target.next('.js-table-cell-accept').toggleClass 'opened'