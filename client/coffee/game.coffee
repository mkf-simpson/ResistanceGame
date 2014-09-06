me = undefined

Template.game.events
  'click .js-player': (event, template) ->
    return unless me.starter
    id = $(event.currentTarget).attr 'data-id'
    game = template?.data?.game
    return unless game?
    mission = game.missions[game.currentMission]
    return if mission.votes isnt null
    players = mission.players.slice()
    if id in players
      players.splice players.indexOf(id), 1
    else
      if players.length < mission.count
        players.push id
    update = {}
    update["missions.#{game.currentMission}.players"] = players
    Games.update game._id, $set: update

  'click .js-start-voting': (event, template) ->
    return unless me.starter
    game = template?.data?.game
    return unless game?
    mission = game.missions[game.currentMission]
    return if mission.votes isnt null
    update = {}
    vote = {}
    vote[me.id] = yes
    update["missions.#{game.currentMission}.votes"] = vote
    Games.update game._id, $set: update

  'click .js-vote': (event, template) ->
    game = template?.data?.game
    return unless game?
    mission = game.missions[game.currentMission]
    return if mission.votes is null
    voteValue = $(event.currentTarget).attr 'data-vote'
    update = {}
    votes = mission.votes
    votes[me.id] = Boolean(~~voteValue)
    update["missions.#{game.currentMission}.votes"] = votes
    Games.update game._id, $set: update

Template.game.me = ->
  return me if me?
  me = @game?.players?.reduce (memo, m) ->
    if m.id is Meteor.user()._id then m else memo
  , null

Template.game.isSpy = (player) ->
  me?.spy and player.spy

Template.game.notMe = (player) ->
  Meteor.user()._id isnt player.id

Template.game.missionClasses = ->
  template = UI._templateInstance()
  "size#{template?.data?.game?.missions?.length}"

Template.game.circleClasses = ->
  if @success is true
    return 'success'
  else if @success is false
    return 'fail'
  else if @current isnt true
    return 'future'

Template.game.checkClasses = ->
  template = UI._templateInstance()
  game = template?.data?.game
  return 'unchecked' unless game?
  if @id in game.missions[game.currentMission].players
    return 'checked'
  else
    return 'unchecked'

Template.game.recruitmentIsNotDone = ->
  not (@game? and @game.missions[@game.currentMission].count is @game.missions[@game.currentMission].players.length)

Template.game.isNotVoting = ->
  not (@game? and @game.missions[@game.currentMission].votes isnt null)

Template.game.voteClasses = ->
  template = UI._templateInstance()
  game = template?.data?.game
  return '' unless game? and game.missions[game.currentMission].votes?
  vote = game.missions[game.currentMission].votes[@id]
  if vote is true
    return 'vote-yes'
  else if vote is false
    return 'vote-no'
  else
    return ''
