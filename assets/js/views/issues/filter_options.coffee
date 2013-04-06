class Option extends Backbone.View

  tagName: 'li'
  
  events:
    'click > div': 'select'

  select: (event) ->
    App.github.filter.user = event.currentTarget.dataset.value
    App.trigger('github:filter:change', event.currentTarget.dataset)

  render: ->
    @$el.html JadeTemplates['templates/issues/filter_option']( @model.toJSON() )

class App.View.GithubFilterOptions extends Backbone.CollectionView

  itemView: Option 

  initialize: (o) ->
    @type = o.type