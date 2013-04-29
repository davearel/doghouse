fs = require 'fs'
_  = require 'underscore'

exports.get = ->
  console.log 'loading and parsing application settings'
  _.extend process.env, JSON.parse(fs.readFileSync(process.cwd() + '/settings.json'))