#### github client library which leans on memcached
#### Craig Ulliott 2013

memcache = require 'memcache'
request = require 'request'

exports.users = (res, req, callback) -> 
  org  = res.locals.config.GITHUB_ORGANIZATION
  access_token = req.session.access_token
  get_from_github_with_memcached res, req, '/orgs/'+org+'/members?access_token='+access_token, callback

exports.repos = (res, req, callback) -> 
  org  = res.locals.config.GITHUB_ORGANIZATION
  access_token = req.session.access_token
  get_from_github_with_memcached res, req, '/orgs/'+org+'/members?access_token='+access_token, callback

exports.open_issues = (res, req, callback) -> 
  org  = res.locals.config.GITHUB_ORGANIZATION
  access_token = req.session.access_token
  get_from_github_with_memcached res, req, '/orgs/'+org+'/issues?filter=all&state=open&access_token='+access_token, callback

# if the data is not in memcache, then we get it from github and cache it for next time
get_from_github_with_memcached = (res, req, path, callback) ->
  host = 'https://api.github.com'

  # first try memcached
  res.locals.memcache.get path, (error, result) ->
    if result
      callback result
    else # get it from github
      request.get host+path, (e, r, b) ->
        console.log 'storing in memcached for next time'
        # store it in memcached for next time
        res.locals.memcache.set path, r.body, 600
        # send the result back
        callback r.body
