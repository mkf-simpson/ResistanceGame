root = @ ? exports

spyCount =
    5: 2
    6: 2
    7: 3
    8: 3
    9: 4
    10: 4

missions =
  5: [2, 3, 2, 3, 3]
  6: [2, 3, 3, 3, 4]
  7: [2, 3, 3, 3, 4, 4, 4]
  8: [3, 3, 3, 4, 4, 4, 5]
  9: [3, 4, 4, 4, 4, 5, 5, 5, 5]
  10: [4, 4, 4, 4, 4, 5, 5, 5, 5, 5]

randomSpies = (players, count) ->
  result = []
  indexes = [0...players]
  for i in [0...count]
    random = Math.floor(Math.random() * indexes.length)
    result.push indexes[random]
    indexes.splice random, 1
  return result

root.Game =
  hash: (roomId) ->
    players = RoomUsers.find({room: roomId, 'player.accepted': yes})
    playersCount = players.count()
    room: roomId
    players: players.map (m) ->
      id: m.player.id
      name: m.player.name
      creator: m.player.creator
      spy: null
      starter: null
    captain: null
    spies: spyCount[playersCount]
    missions: missions[playersCount].map (m, idx) ->
      count: m
      countToFail: if m > 3 then 2 else 1
      players: []
      success: null
      current: idx is 0
      results: []
      votes: null
    currentMission: 0


  start: (game) ->
    fields = {}
    playerCount = game.players.length
    spies =  randomSpies(playerCount, game.spies)
    console.log 'spies: ', spies
    nextIsCaptain = no
    for player, idx in game.players
#      player.spy = idx in spies
      fields["players.#{idx}.spy"] = idx in spies
      if game.captain is null
        if player.creator
#          player.starter = yes
          fields["players.#{idx}.starter"] = yes
#          game.captain = player.id
          fields['captain'] = player.id
      else
        if player.starter and not nextIsCaptain
          nextIsCaptain = yes
#          player.starter = no
          fields["players.#{idx}.starter"] = no
        else if nextIsCaptain
#          player.starter = yes
          fields["players.#{idx}.starter"] = yes
#          game.captain = player.id
          fields['captain'] = player.id
          nextIsCaptain = no

    if nextIsCaptain
      fields['players.0.starter'] = yes
      fields['captain'] = game.players[0].id

    return fields
