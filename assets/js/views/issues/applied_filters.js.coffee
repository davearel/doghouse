class App.View.AppliedFilters extends Backbone.View

  initialize: ->
    App.on 'github:filter:change', @render

  render: =>
    @$el.html JadeTemplates['templates/issues/applied_filters'] value: App.github.filter.user