define 'collections/issues/users', ['models/issues/user'], (User) ->

  class Users extends Backbone.Collection
    model: User
    url: 'github/users'
