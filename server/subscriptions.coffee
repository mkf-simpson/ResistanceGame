Meteor.publish 'allRooms', ->
  Rooms.find()

Meteor.publish 'roomMessages', (roomId) ->
  Messages.find room : roomId

Meteor.publish 'roomUsers', (roomId) ->
  RoomUsers.find room : roomId


Messages.allow
  insert: -> yes

Rooms.allow
  insert: -> yes

RoomUsers.allow
  insert: -> yes
  remove: -> yes
  update: -> yes