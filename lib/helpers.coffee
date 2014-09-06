UI.registerHelper 'cond', (first, second) ->
  first is second

UI.registerHelper 'less', (first, second) ->
  first < second