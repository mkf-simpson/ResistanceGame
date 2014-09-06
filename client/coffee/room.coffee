Template.room.rendered = ->
  Meteor.startup =>
    Deps.autorun =>
      game = Games.findOne room: @data.room._id
      if game? and game?.players?
        iAmPlayer = game.players.some (m) -> m.id is Meteor.user()._id
        if iAmPlayer
          Router.go "/game/#{game._id}"

Template.room.isAlreadyIn = ->
  result = false
  @roomUsers?.forEach (roomUser) ->
    if roomUser.player.id is Meteor.user()._id
      result = roomUser._id
  result

Template.room.isMyRoom = ->
  @room?.creator?.id is Meteor.user()._id

Template.room.roomUserCount = ->
  @roomUsers?.count()

Template.room.events
  'click .js-join-game': (event, template) ->
    RoomUsers.insert
      room: template.data.room._id
      player:
        id: Meteor.user()._id
        name: Meteor.user().profile.name
        creator: no
        accepted: null
      creation_date: new Date()

  'click .js-table-cell': (event, template) ->
    if template.data.room.creator.id is Meteor.user()._id
      $target = $(event.currentTarget)
      userId = $target.attr 'data-playerId'
      if userId isnt Meteor.user()._id
        $target.next('.js-table-cell-accept').toggleClass 'opened'

  'click .js-leave-game': (event, template) ->
    roomUserId = $(event.currentTarget).attr 'data-id'
    RoomUsers.remove roomUserId

  'click .js-accept': (event) ->
    $target = $(event.currentTarget)
    roomUserId = $target.closest('.js-table-cell').attr 'data-id'
    RoomUsers.update(roomUserId, $set: 'player.accepted': yes)

  'click .js-decline': (event) ->
    $target = $(event.currentTarget)
    roomUserId = $target.closest('.js-table-cell').attr 'data-id'
    RoomUsers.update(roomUserId, $set: 'player.accepted': no)


  'click .js-start-game': (event, template) ->
    if Meteor.user()._id is template.data.room.creator.id
      game = Game.hash(template.data.room._id)
      Games.insert game, (err, id) ->
        if not err
          Games.update id, $set: Game.start(game)
