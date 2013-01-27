#= require_tree js

define 'collections', [
  
  'collections/issues/users'
  'collections/issues/repos'

], (UsersCollection, ReposCollection) ->
  collections = {}
  collections.users = new UsersCollection()
  collections.repos = new ReposCollection()
  collections.users.fetch()
  collections.repos.fetch()
  return collections


# Decide what controller use based on URL root
switch PATH_ROOT
  
  when 'issues'
    controller = require 'controllers/issues'