class App.Github.Issues extends Backbone.Collection

  model: App.Github.Issue

  url: 'github/open_issues'