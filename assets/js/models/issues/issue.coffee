define 'models/issues/issue', ->
  class Issue extends Backbone.Model

    initialize: ->
      @formatCreatedAt()

    formatCreatedAt: ->
      @set 'created_at_formatted', moment( @get('created_at') ).from( moment() )