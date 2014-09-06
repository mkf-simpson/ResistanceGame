Accounts.onCreateUser (options, user) ->
  if user?.services?.github?
    accessToken = user.services.github.accessToken

    result = Meteor.http.get "https://api.github.com/user",
      headers:
        'User-Agent': 'Awesome-Octocat-App'
      params:
        access_token: accessToken

    if result.error?
      throw result.error

    profile = _.pick(result.data,
      "login",
      "name",
      "avatar_url",
      "url",
      "company",
      "blog",
      "location",
      "email",
      "bio",
      "html_url")

    user.profile = profile

  if user?.services?.twitter?

    user.profile = user.services.twitter
    user.profile.name = user.services.twitter.screenName

  if user?.services?.facebook?
    user.profile = user.services.facebook

  user