express  = require 'express'
stylus   = require 'stylus'
assets   = require 'connect-assets'
jade     = require 'connect-assets-jade'
mongoose = require 'mongoose'
memcache = require 'memcache'
_        = require 'underscore'

# Create app instance.
app = express()

# Define Port
app.port = process.env.PORT or process.env.VMC_APP_PORT or 3000

# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment app.settings.env
  app.use assets
    jsCompilers:
      jade: jade()

# mongodb connection
mongoose.connect 'mongodb://localhost/doghouse'

# memcached client
memcache = new memcache.Client(config.MEMCACHED_PORT, config.MEMCACHED_HOST)
memcache.on 'connect', () ->
  console.log 'memcache connected'
memcache.on 'close', () ->
  console.log 'memcache closed'
memcache.on 'timeout', () ->
  console.log 'memcache timeout'
memcache.on 'error', (e) ->
  console.log 'memcache error'
  console.log e
memcache.connect()

# helpers
app.configure ->
  app.use (req, res, next) ->
    # make the config available throughout the application
    res.locals.config = config
    res.locals.path_root = req._parsedUrl.path.split( '/' )[1]
    console.log req

    # url helpers
    ## TODO: Create a file structure for these, we want to keep this file lighter
    res.locals.github_connect_url = 'https://github.com/login/oauth/authorize?client_id='+config.GITHUB_CLIENT_ID+'&scope=repo'
    res.locals.logout_path = '/users/logout'
    res.locals.issues_path = '/issues'
    # events
    res.locals.events_path = '/events'
    res.locals.new_event_path = '/events/new'
    res.locals.create_event_path = '/events/create'
    res.locals.edit_event_path = (event) ->
      '/events/'+event.id+'/edit'
    res.locals.update_event_path = (event) ->
      '/events/'+event.id+'/update'
    res.locals.delete_event_path = (event) ->
      '/events/'+event.id+'/delete'
    # 
    res.locals.root_path = '/'

    # memcache and mongoose
    res.locals.memcache = memcache
    res.locals.mongoose = mongoose

    # template helpers
    ## TODO: Create a file structure for these, we want to keep this file lighter
    res.locals.loggedIn = () ->
      ! _.isEmpty req.session
    next()

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
