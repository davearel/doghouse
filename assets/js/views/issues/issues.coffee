class Issue extends Backbone.View
  className: 'issue span6'

  render: -> 
    _.each @model.get('labels'), (label) =>
      if label.name.toLowerCase() is 'bug' then @$el.addClass('labeled bug')
      if label.name.toLowerCase() is 'priority' then @$el.addClass('labeled priority')
    
    @$el.html JadeTemplates['templates/issues/issues']( @model.toJSON() )


class App.View.GithubIssues extends Backbone.View
  itemView: Issue

  initialize: ->
    App.on 'github:filter:change', @render

  renderItem: (model) =>
    # return unless model matches filter properties
    if App.github.filter.user?
      return unless model.attributes.assignee?.login is App.github.filter.user

    item = new @itemView({ model: model })
    item.render()
    @$placeholder.append( item.el )

    # store our item 
    @items.push( item )

  render: =>
    @$placeholder = $('<div />')
    @items = []  # stores our collection of reward views
    @collection.each( @renderItem )
    @$el.html @$placeholder.children()