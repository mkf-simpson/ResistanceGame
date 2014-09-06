Meteor.publish 'allRooms', ->
  Rooms.find()

Meteor.publish 'roomMessages', (roomId) ->
  Messages.find room: roomId

Meteor.publish 'roomUsers', (roomId) ->
  RoomUsers.find {room: roomId}, {sort: {'player.creator': -1, 'player.accepted': -1, 'creation_date': 1}}

Meteor.publish 'gameStarted', (roomId) ->
  Games.find {room: roomId}

Meteor.publish 'games', (gameId) ->
  Games.find gameId

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

Games.allow
  insert: -> yes
  update: -> yes