request = require 'request'
github = require '../lib/github_client'
User = require '../models/user'
settings = require '../lib/settings'

github_client_id = settings.get("github").client_id
github_secret = settings.get("github").secret

# 1) after oauth connection with github we land here, 
# 2) convert the code into an access_token
# 3) store in the session
# 4) redirect back to the homepage
exports.callback = (req, res) ->
  request_data =
    url: 'https://github.com/login/oauth/access_token'
    json: true
    body:
      "client_id": github_client_id
      "client_secret": github_secret
      "code": req.query.code

  # switch code for an access token
  request.post request_data, (e, r, b) ->
    access_token = r.body.access_token
    # update or create this user record in the database
    find_or_create_user_from_github_access_token access_token, (user) ->

      # login this users by putting their user id in the session
      req.session.user_id = user.id
      # redirect back to the homepage
      res.redirect '/'

# return a list of members on the current organization
exports.users = (req, res) ->
  res.set 'Content-Type', 'application/json'
  github.users res, req.session.user_id, (r) ->
    res.send r

# return a list of repositories in the current organization
exports.repos = (req, res) ->
  res.set 'Content-Type', 'application/json'
  github.repos res, req.session.user_id, (r) ->
    res.send r

# return a list of repositories in the current organization
exports.open_issues = (req, res) ->
  res.set 'Content-Type', 'application/json'
  github.open_issues res, req.session.user_id, (r) ->
    res.send r

find_or_create_user_from_github_access_token = (access_token, callback) ->
  # get the user object from github
  request.get 'https://api.github.com/user?access_token=' + access_token, (e, r, b) ->
    github_user = JSON.parse(r.body)
    # find or create by github user
    User.findOne github_id: github_user.id, (err, user) ->
      # if no user, create a new one
      unless user
        user = new User
      # update the existing or new user with current data from github
      user.access_token = access_token
      user.github_id = github_user.id
      user.login = github_user.login
      user.name = github_user.name
      user.save (err, user) ->
        if not err
          callback(user)
        else
          res.statusCode = 500
          res.redirect '/'



