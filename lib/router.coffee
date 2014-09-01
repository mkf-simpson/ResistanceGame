Router.configure
  layoutTemplate: 'layout'

Router.onBeforeAction ->
  unless Meteor.userId()?
    Router.go 'home'
, except: 'home'

Router.map ->

  @route 'home',
    path: '/'
    template: 'home'
    onBeforeAction: ->
      if Meteor.userId()?
        Router.go 'rooms'

  @route 'loginRedirectRoute',
    action: ->
      console.log '1243874987'
      Router.go '/rooms'

  @route 'room', ->
    path: '/room/:id'
    template: '/room'
    loginRequired: 'home'

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
      console.log roomsList
      rooms : roomsList

  @route 'logout',
    path: 'logout',
    action: ->
      Meteor.logout ->
        Router.go 'home'