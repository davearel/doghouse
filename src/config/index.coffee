#### Config file
fs = require 'fs'
# Sets application config parameters depending on `env` name
exports.setEnvironment = (env) ->
  console.log "set app environment: #{env}"
  settings = JSON.parse(fs.readFileSync(process.cwd() + '/settings.json'))[env]
  switch(env)

    when "development"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      # mongoose
      exports.DB_HOST = 'localhost'
      exports.DB_PORT = "27017"
      exports.DB_NAME = 'doghouse'
      exports.DB_USER = ''
      exports.DB_PASS = ''
      # github
      exports.GITHUB_CLIENT_ID = settings.github.client_id
      exports.GITHUB_SECRET = settings.github.secret
      exports.GITHUB_ORGANIZATION = settings.github.organization
      # memcached
      exports.MEMCACHED_PORT = settings.memcached.port
      exports.MEMCACHED_HOST = settings.memcached.host
      # cookies
      exports.COOKIE_SECRET = settings.cookie_secret
      # sessions
      exports.SESSION_SECRET = settings.session_secret

    when "testing"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true

    when "production"
      exports.DEBUG_LOG = false
      exports.DEBUG_WARN = false
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = false
      
    else
      console.log "environment #{env} not found"