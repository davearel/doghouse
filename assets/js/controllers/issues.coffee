define 'controllers/issues', [

  # dependencies
  'collections/issues/users'
  'collections/issues/issues'
  'collections/issues/repos'
  'views/issues/issues'
  'views/issues/filter_form'


], ( Users, Issues, Repos, IssuesView, FilterFormView ) ->

  # create the issues view items
  issues = new Issues()
  issues.fetch
    success: ->
      console.log issues
      issues_view = new IssuesView
        el: '.issue-list'
        collection: issues
      issues_view.render()

      # create filter form view
      filter_form_view = new FilterFormView
        el: '#filter-group'
      filter_form_view.render()

  ###
  repos = new Repos()
  repos.fetch
    success: ->
      console.log repos.toJSON()