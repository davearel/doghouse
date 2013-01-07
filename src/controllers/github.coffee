request = require 'request'
 
# 1) after oauth connection with github we land here, 
# 2) convert the code into an access_token
# 3) store in the session
# 4) redirect back to the homepage
exports.callback = (req, res) ->
  request_data =
    url: 'https://github.com/login/oauth/access_token',
    json: true
    body: {
      "client_id": res.locals.config.GITHUB_CLIENT_ID,
      "client_secret": res.locals.config.GITHUB_SECRET,
      "code": req.query.code
    }
  request.post request_data, (e, r, b) ->
    req.session.access_token = r.body.access_token
    res.redirect '/'

# return a list of members on the current organization
exports.users = (req, res) ->
  request.get 'https://api.github.com/orgs/'+res.locals.config.GITHUB_ORGANIZATION+'/members?access_token='+req.session.access_token, (e, r, b) ->
    res.set('Content-Type', 'application/json');
    res.send r.body

# return a list of repositories in the current organization
exports.repos = (req, res) ->
  request.get 'https://api.github.com/orgs/'+res.locals.config.GITHUB_ORGANIZATION+'/repos?access_token='+req.session.access_token, (e, r, b) ->
    res.set('Content-Type', 'application/json');
    res.send r.body

# return a list of repositories in the current organization
exports.open_issues = (req, res) ->
  res.set('Content-Type', 'application/json');
  # first try memcached
  key = 'open_issues'
  res.locals.memcache.get key, (error, result) ->
    if result
      res.send result
    else # get it from github
      request.get 'https://api.github.com/orgs/'+res.locals.config.GITHUB_ORGANIZATION+'/issues?filter=all&state=open&access_token='+req.session.access_token, (e, r, b) ->
        # store it in github for next time
        res.locals.memcache.set key, r.body, 600
        # send the result back
        res.send r.body
