class App.Controller.Issues

  constructor: ->

    # sets a generic flag for filter properties
    App.github = filter: user: undefined

    # get our github users
    App.github.users = new App.Github.Users()
    App.github.users.fetch()

    # create the issues view items
    issues = new App.Github.Issues()
    issues.fetch
      success: ->

        # the issue view
        issues_view = new App.View.GithubIssues
          el: '.issue-list'
          collection: issues
        issues_view.render()

        # create filter form view
        filter_form_view = new App.View.GithubForm
          el: '#filter-group'
        filter_form_view.render()

        # A view to manage our filter labels
        applied_filters = new App.View.AppliedFilters
          el: '.applied-filters'
        applied_filters.render()

    # generic jquery click handler to clear github filters
    $('#filter-applied').find('.clear').on 'click', ->
      App.github.filter.user = undefined
      App.trigger 'github:filter:change'