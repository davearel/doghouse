fs = require 'fs'
_  = require 'underscore'

exports.extend = ->
  return unless process.env.NODE_ENV is 'development'
  console.log 'loading and parsing application settings'
  _.extend process.env, JSON.parse(fs.readFileSync(process.cwd() + '/settings.json'))

exports.get = (key) ->
  return process.env[key]