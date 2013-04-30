Memcached = require 'memcached'
settings = require './settings'

memcached = null

exports.get = (cache_key, callback) ->
  memcached.get cache_key, (error, result) ->
    console.log error if error
    callback result

exports.set = (cache_key, value, timeout, callback) ->
  memcached.set cache_key, value, timeout, (error, result) ->
    console.log error if error
    callback result

prepare_connection = () ->
  # memcached client (uses a connection pool)
  memcached = new Memcached( settings.get 'memcached_servers' )

prepare_connection()