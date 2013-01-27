define 'views/issues/filter_options', ->

  class Option extends Backbone.View

    tagName: 'li'
    
    events:
      'click': 'select'

    select: (event) ->
      @trigger('select', this)

    render: ->
      @$el.html JadeTemplates['templates/issues/filter_option']( @model.toJSON() )

  class Options extends Backbone.CollectionView

    itemView: Option 

    initialize: (o) ->
      @type = o.type

    viewEvents:
      'select': 'onItemSelect'

    onItemSelect: (view) ->
      switch @type
        when 'user'
          console.log @type

  return Options