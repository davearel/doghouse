define 'views/issues/filter_form', [
  
  'views/issues/filter_options'
  'collections'

], (Options, collections) ->

  class Form extends Backbone.View

    render: ->
      @$el.append JadeTemplates['templates/issues/filter_form']()
      console.log collections.users
      person = new Options
        el: @$('.person .dropdown-menu')
        collection: collections.users
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