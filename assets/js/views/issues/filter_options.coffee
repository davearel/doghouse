class Option extends Backbone.View

  tagName: 'li'
  
  events:
    'click > div': 'select'

  selected: false

  initialize: ->
    App.on 'remove:filter', @checkIfRemoved

  checkIfRemoved: (o) =>
    if o.key is 'all' or o.key is @$el.data('key')
      @selected = false
      @$el.removeClass('selected')

  select: (event) ->
    data = event.currentTarget.dataset
    if @selected
      @selected = false
      @$el.removeClass('selected')
      App.github.search_filters.remove data.key, data.value
    else
      @selected = true
      @$el.addClass('selected')
      App.github.search_filters.add data.key, data.value

  render: (type) ->
    @$el.html JadeTemplates['templates/issues/filter_option']( _.extend @model.toJSON(), { type: type } )

class App.View.GithubFilterOptions extends Backbone.View

  initialize: (o) ->
    @type = o.type

  renderItem: (model) =>
    item = new Option({ model: model })
    item.render( @type )
    @$placeholder.append( item.el )

    # store our item 
    @items.push( item )

  render: =>
    @$placeholder = $('<div />')
    @items = []  # stores our collection of reward views
    @collection.each( @renderItem )
    @$el.html @$placeholder.children()