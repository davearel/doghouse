class App.Router extends Backbone.Router

  routes:
    'issues': 'issues'

  issues: (params) ->
    # Check if the controller has been instantiated or not
    if _.isEmpty App.controller
      App.controller = new App.Controller.Issues params
    else
      App.controller.resetFilterParams params