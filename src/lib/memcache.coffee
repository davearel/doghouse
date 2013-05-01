memjs     = require 'memjs'
settings  = require './settings'

memcached = null

exports.get = (cache_key, callback) ->
  memcached.get cache_key, (error, result) ->
    console.log error if error
    callback result

exports.set = (cache_key, value, callback) ->
  memcached.set cache_key, value, (error, result) ->
    console.log error if error
    callback result

prepare_connection = () ->
  memcached = memjs.Client.create()

prepare_connection()
