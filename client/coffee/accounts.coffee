authCB = (err) ->
  if err
    console.err err

Template.home.events
  'click .js-login-github': ->
    Meteor.loginWithGithub
      requestPermissions: ['user', 'public_repo']
    , authCB

  'click .js-login-twitter': ->
    Meteor.loginWithTwitter()


Handlebars.registerHelper 'arrayify', (obj) ->
  result = [];
  for key, value of obj
    result.push
      name: key
      value: value
  result
