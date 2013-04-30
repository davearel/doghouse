class App.View.GithubForm extends Backbone.View

  render: ->
    @$el.append JadeTemplates['templates/issues/filter_form']()

    # render the user filter options
    person = new App.View.GithubFilterOptions
      el: @$('.person .dropdown-menu')
      collection: App.github.users
      type: 'user'
    person.render()

    # render the week/milestone filter options
    week = new App.View.GithubFilterOptions
      el: @$('.week .dropdown-menu')
      collection: App.github.milestones
      type: 'milestone'
    week.render()

    # render the repo filter options
    repo = new App.View.GithubFilterOptions
      el: @$('.repo .dropdown-menu')
      collection: App.github.repos
      type: 'repo'
    repo.render()

    # render the projects filter options
    project = new App.View.GithubFilterOptions
      el: @$('.project .dropdown-menu')
      collection: App.github.projects
      type: 'project'
    project.render()
