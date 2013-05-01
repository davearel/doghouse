class App.View.AppliedFilters extends Backbone.View

  events:
    'click .remove': 'clear'

  initialize: ->
    App.github.search_filters.on 'add:filter remove:filter', @render

  render: =>
    @$el.html JadeTemplates['templates/issues/applied_filters'] categories: App.github.search_filters.toJSON()

  clear: (event) ->
    data = event.currentTarget.dataset
    App.github.search_filters.remove data.key, data.value
    @render()
