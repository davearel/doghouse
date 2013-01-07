request = require 'request'
github = require '../lib/github_client'

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
  res.set('Content-Type', 'application/json');
  github.users res, req, (r) ->
    res.send r

# return a list of repositories in the current organization
exports.repos = (req, res) ->
  res.set('Content-Type', 'application/json');
  github.repos res, req, (r) ->
    res.send r

# return a list of repositories in the current organization
exports.open_issues = (req, res) ->
  res.set('Content-Type', 'application/json');
  github.open_issues res, req, (r) ->
    res.send r
