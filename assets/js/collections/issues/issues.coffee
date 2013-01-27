define 'collections/issues/issues', ['models/issues/issue'], (Issue) ->
  
  class Issues extends Backbone.Collection
    model: Issue
    url: 'github/open_issues'