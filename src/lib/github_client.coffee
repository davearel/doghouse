#### github client library which leans on memcached
#### Craig Ulliott 2013

memcache = require 'memcache'
request = require 'request'
settings = require './settings'

organization = settings.get("github").organization
github_api_base_uri = 'https://api.github.com'

exports.users = (user_id, callback) -> 
  User.findById user_id, (err, user) ->
    get_from_github_with_memcached '/orgs/'+organization+'/members?access_token='+user.access_token, callback

exports.repos = (user_id, callback) -> 
  User.findById user_id, (err, user) ->
    get_from_github_with_memcached '/orgs/'+organization+'/members?access_token='+user.access_token, callback

exports.open_issues = (user_id, callback) -> 
  User.findById user_id, (err, user) ->
    get_from_github_with_memcached user, '/orgs/'+organization+'/issues?filter=all&state=open&access_token='+user.access_token, callback

# get data from github, with a 10 minute cache
get_from_github_with_memcached = (user, path_with_params, callback) ->

  # name space it - because we have shared cache servers
  key = 'doghouse|github|'+path
  
  # first try memcached
  memcache.get key, (error, result) ->
  
    if result
      # parse the result which is already in memcache
      response = JSON.parse(result)
      callback response
  
    else 

      # get it from github and cache the response
      request.get github_api_base_uri + path_with_params, (e, r, b) ->

        # store the response in memcached for next time (up to 10 minutes)
        memcache.set cache_key, r.body, 600, (result) ->

          response = JSON.parse(r.body)
          # send the result back via the callback
          callback response
