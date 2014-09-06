Router.configure
  layoutTemplate: 'layout'

Router.onBeforeAction ->
  unless Meteor.userId()?
    Router.go 'home'
, except: 'home'

Router.onBeforeAction () ->
  Template.layout.hiddenBack @route.options.hiddenBack
  Template.layout.backAction = @route.options.backAction or ->

Router.map ->

  @route 'home',
    path: '/'
    template: 'home'
    onBeforeAction: ->
      if Meteor.userId()?
        Router.go 'rooms'
    hiddenBack: true

  @route 'room',
    path: '/room/:id'
    template: 'room'
    waitOn: ->
      Meteor.subscribe 'allRooms'
      Meteor.subscribe 'roomUsers', @params.id
      Meteor.subscribe 'gameStarted', @params.id
    action: ->
      @render()
    data: ->
      room: Rooms.findOne _id: @params.id
      roomUsers: RoomUsers.find({ room : @params.id }, {sort: {'player.creator': -1, 'player.accepted': -1, 'creation_date': 1}})
    backAction: ->
      Router.go 'rooms'

  @route 'rooms',
    path: '/rooms'
    template: 'roomList'
    waitOn: ->
      Meteor.subscribe 'allRooms'
    action: ->
      if Meteor.user()?
        username = Meteor.user().profile.name
        Session.set 'userName', username
      @render()

    data: ->
      roomsList = Rooms.find({}, {sort : {creation_date : 'desc'}});
      rooms : roomsList

    hiddenBack: true

  @route 'game',
    path: '/game/:id'
    template: 'game'
    waitOn: ->
      Meteor.subscribe 'games', @params.id
    data: ->
      game: Games.findOne @params.id
    backAction: ->
      Router.go 'rooms'

  @route 'logout',
    path: 'logout',
    action: ->
      Meteor.logout ->
        Router.go 'home'