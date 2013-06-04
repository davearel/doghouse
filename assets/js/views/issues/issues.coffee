class Issue extends Backbone.View
  className: 'issue span6'

  render: -> 
    _.each @model.get('labels'), (label) =>
      name = label.name.toLowerCase()
      if name is 'bug' then @$el.addClass('labeled bug')
      if name is 'priority' then @$el.addClass('labeled priority')
      if name is 'blocked' then @$el.addClass('labeled blocked')

    if @model.get('is_pull') then @$el.addClass('labeled pull')

    @$el.html JadeTemplates['templates/issues/issues']( @model.toJSON() )


class App.View.GithubIssues extends Backbone.View

  initialize: ->
    App.on 'change:filter', @render

  renderItem: (model) =>

    match = model.get('filterMatch')
    # return unless model matches filter properties
    return if match is false

    item = new Issue({ model: model })
    item.render()
    @$placeholder.append( item.el )

    # store our item 
    @items.push( item )

  render: =>
    @$placeholder = $('<div />')
    @items = []  # stores our collection of reward views
    @collection.each( @renderItem )
    @$el.html @$placeholder.children()

    $('#issue-count').text( @items.length + if @items.length isnt 1 then ' issues' else ' issue' )
