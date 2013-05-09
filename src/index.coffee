path        = require 'path'
express     = require 'express'
stylus      = require 'stylus'
assets      = require 'connect-assets'
jadeAssets  = require 'connect-assets-jade'
mongoose    = require 'mongoose'
_           = require 'underscore'
User        = require './models/user'
settings    = require './lib/settings'

# extend the settings
settings.extend()

# Create app instance.
app = express()

# Define Port
app.port = process.env.PORT or process.env.VMC_APP_PORT or 3000

# Set up views
app.set 'view engine', 'jade'
app.set 'view options', layout: false

# Set public directory
app.use express.static(process.cwd() + '/public')

# Set up jade assets
app.use(assets({
  jsCompilers: jade: jadeAssets()
}))

# View helper for the current logged-in state
app.use (req, res, next) ->
  res.locals.loggedIn = () ->
    req.session.logged_in
  next()

# Sessions and cookies
app.use(express.cookieParser( settings.get 'cookie_secret' ))

app.use(express.cookieSession(
  secret : settings.get('session_secret')
  maxAge : new Date(Date.now() + 3600000)
))

# Body parser middleware
app.use express.bodyParser()

# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment process.env.NODE_ENV

# Here we find an appropriate database to connect to, defaulting to
# localhost if we don't find one.  
mongo_url = process.env.MONGOHQ_URL or 'mongodb://localhost/doghouse'

# mongodb connection
mongoose.connect mongo_url

# make routes and other helpers available in our views
app.locals.routes = require("./helpers/routes")

# pretty print the html output in development
app.locals.pretty = true if process.env.NODE_ENV is 'development'

# Initialize routes
routes = require './routes'
routes(app)

# Export application object
module.exports = app
