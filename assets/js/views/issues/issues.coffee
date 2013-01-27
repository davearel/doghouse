define 'views/issues/issues', ->

  class Issue extends Backbone.View
    className: 'issue span6'

    initialize: ->
      @filter.on ('')

    render: -> 

      _.each @model.get('labels'), (label) =>
        if label.name.toLowerCase() is 'bug' then @$el.addClass('labeled bug')
        if label.name.toLowerCase() is 'priority' then @$el.addClass('labeled priority')
      
      @$el.html JadeTemplates['templates/issues/issues']( @model.toJSON() )

    respond: ->
      console.log @model.toJSON()

    filter: (sort) ->
      if @model.get('assignee')
        if @model.get('assignee').login is 'jdoconnor'
          @$el.show()
        else
          @$el.hide()
      else
        @$el.hide()


      ######################################
      ######################################

      if not _.noEmpty @filter.get('users')
        return if _.contains @filter.get('users'), @model.get('assignee.id')

      if not _.noEmpty @filter.get('milestone')
        return if _.contains @filter.get('milestone'), @model.get('milestone.id')

      if not _.noEmpty @filter.get('users')
        return if _.contains @filter.get('users'), @model.get('assignee.id')

      if not _.noEmpty @filter.get('users')
        return if _.contains @filter.get('users'), @model.get('assignee.id')




      ######################################
      ######################################


  class Issues extends Backbone.View
    itemView: Issue
    events:
      'click': 'blah'

    blah: ->
      _.each @items, (item) ->
        item.filter()

    renderItem: (model) =>
      item = new @itemView({ model: model })
      item.render()
      @$placeholder.append( item.el )

      # store our item 
      @items.push( item )

    render: ->
      @$placeholder = $('<div />')
      @items = []  # stores our collection of reward views
      @collection.each( @renderItem )
      @$el.html @$placeholder.children()

  return Issues