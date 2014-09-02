Meteor.publish 'allRooms', ->
  Rooms.find()

Meteor.publish 'roomMessages', (roomId) ->
  Messages.find room: roomId

Meteor.publish 'roomUsers', (roomId) ->
  RoomUsers.find room: roomId


Messages.allow
  insert: -> yes

Rooms.allow
  insert: -> yes
  remove: (id, room) ->
    room.creator.id is Meteor.user()._id

RoomUsers.allow
  insert: -> yes
  remove: -> yes
  update: -> yes