class App.Controller.Issues

  # tracks the filter collection loaded
  filters_loaded: 0

  constructor: (@filter_params) ->

    # stores our github view and data instances
    App.github = {}

    # stores our current search filters
    App.github.search_filters = new App.Github.SearchFilters @filter_params
    
    # get our github users
    App.github.users = new App.Github.Users()
    App.github.users.fetch success: @filterReady

    # get our github milestones
    App.github.milestones = new App.Github.Milestones()
    App.github.milestones.fetch success: @filterReady

    # get our github repositories
    App.github.repos = new App.Github.Repos()
    App.github.repos.fetch success: @filterReady

    # get our github projects
    App.github.projects = new App.Github.Projects()
    App.github.projects.fetch success: @filterReady

    # create the issues view items
    App.github.issues = new App.Github.Issues()
    App.github.issues.fetch
      success: =>
        # the issue view
        issues_view = new App.View.GithubIssues
          el: '.issue-list'
          collection: App.github.issues
        issues_view.render()

    # generic jquery click handler to clear github filters
    $('#filter-applied').find('.clear').on 'click', ->
      App.github.search_filters.reset()


  # triggers when any filter collection is ready
  # and checks to see if we are ready to render the view
  filterReady: =>
    # if all collections have been loaded
    if ( @filters_loaded += 1 ) is 4

      # create filter form view
      filter_form_view = new App.View.GithubForm
        el: '#filter-group'
      filter_form_view.render()

      # A view to manage our filter labels
      applied_filters = new App.View.AppliedFilters
        el: '.applied-filters'
      applied_filters.render()

  resetFilterParams: (params) =>
    if params?
      App.github.search_filters.set params
    else
      App.github.search_filters.reset()
