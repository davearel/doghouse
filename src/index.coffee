express  = require 'express'
stylus   = require 'stylus'
assets   = require 'connect-assets'
jade     = require 'connect-assets-jade'
mongoose = require 'mongoose'
_        = require 'underscore'
User     = require './models/user'

# Create app instance.
app = express()

# Define Port
app.port = process.env.PORT or process.env.VMC_APP_PORT or 3000

# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment process.env.NODE_ENV
  app.use assets
    jsCompilers:
      jade: jade()

# mongodb connection
mongoose.connect 'mongodb://localhost/doghouse'

# make routes and other helpers available in our views
app.locals.routes = require("./helpers/routes")

# helpers
app.configure ->
  app.use (req, res, next) ->
    # view helper for the current logged-in state
    res.locals.loggedIn = () ->
      ! _.isEmpty req.session
    next()

# sessions in cookies
app.use(express.cookieParser(process.env['cookie_secret']))
app.use(express.cookieSession(
  secret : process.env['session_secret'],
  maxAge : new Date(Date.now() + 3600000)
))

# Add Connect Assets.
app.use assets()
# Set the public folder as static assets.
app.use express.static(process.cwd() + '/public')

# Set View Engine.
app.set 'view engine', 'jade'
# pretty print the html output in development
app.locals.pretty = true if process.env.NODE_ENV is 'development'

# [Body parser middleware](http://www.senchalabs.org/connect/middleware-bodyParser.html) parses JSON or XML bodies into `req.body` object
app.use express.bodyParser()

# Initialize routes
routes = require './routes'
routes(app)

# Export application object
module.exports = app
