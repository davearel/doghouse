express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
mongoose = require 'mongoose'
GitHubApi = require 'github'
_ = require 'underscore'

github = new GitHubApi
  version: "3.0.0",
  timeout: 5000

# Create app instance.
app = express()

# Define Port
app.port = process.env.PORT or process.env.VMC_APP_PORT or 3000

# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment app.settings.env

# helpers
app.configure ->
  app.use (req, res, next) ->
    # make the config available throughout the application
    res.locals.config = config
    
    # url helpers
    ## TODO: Create a file structure for these, we want to keep this file lighter
    res.locals.github_connect_url = 'https://github.com/login/oauth/authorize?client_id='+config.GITHUB_CLIENT_ID+'&scope=repo'
    res.locals.logout_path = '/users/logout'
    res.locals.issues_path = '/issues'
    res.locals.root_path = '/'

    # template helpers
    ## TODO: Create a file structure for these, we want to keep this file lighter
    res.locals.loggedIn = () ->
      ! _.isEmpty req.session
    next()


# mongodb connection
mongoose.connect 'mongodb://localhost/example'

# sessions in cookies
app.use(express.cookieParser(config.COOKIE_SECRET))
app.use(express.cookieSession(
  secret : config.SESSION_SECRET,
  maxAge : new Date(Date.now() + 3600000)
))

# Add Connect Assets.
app.use assets()
# Set the public folder as static assets.
app.use express.static(process.cwd() + '/public')

# Set View Engine.
app.set 'view engine', 'jade'
# pretty print the html output
app.locals.pretty = true

# [Body parser middleware](http://www.senchalabs.org/connect/middleware-bodyParser.html) parses JSON or XML bodies into `req.body` object
app.use express.bodyParser()

# Initialize routes
routes = require './routes'
routes(app)

# Export application object
module.exports = app
