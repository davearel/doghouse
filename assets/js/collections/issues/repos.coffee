define 'collections/issues/repos', ['models/issues/repo'], (Repo) ->

  class Repos extends Backbone.Collection
    model: Repo
    url: 'github/repos'