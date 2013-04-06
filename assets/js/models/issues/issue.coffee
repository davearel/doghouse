class App.Github.Issue extends Backbone.Model

  initialize: ->
    @computeAttributes()

  computeAttributes: ->
    @set 'created_at_formatted', moment( @get('created_at') ).from( moment() )