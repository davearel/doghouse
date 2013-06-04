class App.Github.Issue extends Backbone.Model

  initialize: ->
    @computeAttributes()

    App.on 'change:filter', @checkFilter

    @checkFilter()

  computeAttributes: ->
    @set 'created_at_formatted', moment( @get('created_at') ).from( moment() )
    if @get('pull_request').html_url? then @set('is_pull', true)
    project = _.find @get('labels'), (label) -> 
      label.name.substring(0,1) is ':'
    if project?
      @set 'project', project.name.replace(':', '')
    else
      @set 'project', false

  # A bit of a hacky way to check against each issue
  # and mark it as filtered or not
  checkFilter: =>
    filters = App.github.search_filters
    users = filters.get('user')
    milestones = filters.get('milestone')
    repos = filters.get('repo')
    projects = filters.get('project')

    doesPass = =>
      # if users filter is not empty
      unless _.isEmpty users
        return false unless _.contains users, @get('assignee')?.login

      # if milestones filter is not empty
      unless _.isEmpty milestones
        return false unless _.contains milestones, @get('milestone')?.title

      # if repos filter is not empty
      unless _.isEmpty repos
        return false unless _.contains repos, @get('repository')

      # if projects filter is not empty.
      # this check is pretty heavy. Would be nice
      # to find a way to make this a bit more effecient
      unless _.isEmpty projects
        does_contain = false
        _.each @get('labels'), (label) ->
          if _.contains projects, label.name.toLowerCase().replace(':', '')
            does_contain = true
        return does_contain

      # if all passes, return true
      return true

    # set to true or false, 
    @set 'filterMatch', doesPass()