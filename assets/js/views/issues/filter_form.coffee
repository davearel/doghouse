class App.View.GithubForm extends Backbone.View

  render: ->
    @$el.append JadeTemplates['templates/issues/filter_form']()
    person = new App.View.GithubFilterOptions
      el: @$('.person .dropdown-menu')
      collection: App.github.users
      type: 'user'
    person.render()
    person.renderAllItems()
