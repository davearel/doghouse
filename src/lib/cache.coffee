redis     = require 'redis'
url       = require 'url'
settings  = require './settings'

client = null

exports.get = (cache_key, callback) ->
  client.get cache_key, (error, result) ->
    console.log error if error
    callback? result

exports.set = (cache_key, value, expires, callback) ->
  client.set cache_key, value, (error, result) ->
    console.log error if error
    callback? result
  if expires?
    client.expire cache_key, expires

prepare_connection = ->
  if process.env.REDISTOGO_URL
    rtg   = url.parse process.env.REDISTOGO_URL
    client = redis.createClient rtg.port, rtg.hostname
    client.auth rtg.auth.split(":")[1]
  else
    client = redis.createClient()

  # log errors
  client.on 'error', (err) -> console.log "Error #{err}"

prepare_connection()
