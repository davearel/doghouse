class App.Router extends Backbone.Router

  routes:
    'issues': 'issues'

  issues: (params) ->
    console.log App.controller
    if _.isEmpty App.controller
      App.controller = new App.Controller.Issues params
    else
      App.controller.resetFilterParams params