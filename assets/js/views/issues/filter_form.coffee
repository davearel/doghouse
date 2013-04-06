class App.View.GithubForm extends Backbone.View

  render: ->
    @$el.append JadeTemplates['templates/issues/filter_form']()
    person = new App.View.GithubFilterOptions
      el: @$('.person .dropdown-menu')
      collection: App.github.users
      type: 'user'
    person.render()
    person.renderAllItems()

    # week = new Option
    #   el: @$('.week .dropdown-menu')
    #   collection: collections.users
    # week.render()
    # week.renderAllItems()
    
    # repo = new Option
    #   el: @$('.repo .dropdown-menu')
    #   collection: collections.users
    # repo.render()
    # repo.renderAllItems()
    
    # project = new Option
    #   el: @$('.project .dropdown-menu')
    #   collection: collections.users
    # project.render()
    # project.renderAllItems()