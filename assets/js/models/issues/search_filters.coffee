class App.Github.SearchFilters extends Backbone.Model

  # stores an array of each filter property
  defaults: ->
    'users': []
    'milestones': []
    'repos': []
    'projects': []

  # gets the current value of
  # a filter property and pushes the
  # new value to the array, and sets the new array
  add: (key, value) ->
    array = @get key
    array.push value
    @set key, array

    # reflect the paramters in the url
    App.router.navigate App.router.toFragment 'issues', @toJSON()

    # for some reason, the 'change' event does 
    # not get triggered automatically
    @trigger 'add:filter', { key: key, value: value }

  # removes value from array
  remove: (key, value) ->
    array = @get key
    array = _.without array, value
    @set key, array

    # reflect the paramters in the url
    App.router.navigate App.router.toFragment 'issues', @toJSON()

    # for some reason, the 'change' event does 
    # not get triggered automatically
    @trigger 'remove:filter', { key: key, value: value }


  # check to see if all values are empty or not
  hasProperties: ->
    for key, value of @attributes
      return true unless _.isEmpty value
    return false

  reset: ->
    @clear()
    @set @defaults()
    # reflect the paramters in the url
    App.router.navigate App.router.toFragment('issues', @toJSON())
    @trigger 'remove:filter', key: 'all'