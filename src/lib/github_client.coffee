#### github client library which leans on memcached
#### Craig Ulliott 2013

memcache = require 'memcache'
request = require 'request'

exports.users = (res, user_id, callback) -> 
  org  = res.locals.config.GITHUB_ORGANIZATION
  User.findById user_id, (err, user) ->
    get_from_github_with_memcached res, req, '/orgs/'+org+'/members?access_token='+user.access_token, callback

exports.repos = (res, user_id, callback) -> 
  org  = res.locals.config.GITHUB_ORGANIZATION
  User.findById user_id, (err, user) ->
    get_from_github_with_memcached res, req, '/orgs/'+org+'/members?access_token='+user.access_token, callback

exports.open_issues = (res, user_id, callback) -> 
  org  = res.locals.config.GITHUB_ORGANIZATION
  User.findById user_id, (err, user) ->
    get_from_github_with_memcached res, user, '/orgs/'+org+'/issues?filter=all&state=open&access_token='+user.access_token, callback

# if the data is not in memcache, then we get it from github and cache it for next time
get_from_github_with_memcached = (res, user, path, callback) ->
  host = 'https://api.github.com'
  key = 'github:'+path
  # first try memcached
  res.locals.memcache.get key, (error, result) ->
    if result
      callback result
    else # get it from github
      request.get host+path, (e, r, b) ->
        console.log 'storing '+key+' in memcached for next time'
        # store it in memcached for next time
        res.locals.memcache.set key, r.body, 600
        # send the result back
        callback r.body
