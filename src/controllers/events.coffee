Event = require '../models/event'
current_user = require '../lib/current_user'

exports.index = (req, res) ->
  Event.find {}, (err, events) ->
    res.render 'events/index',  events: events

exports.new = (req, res) ->
  res.render 'events/form'

exports.create = (req, res) ->
  current_user.do req, (user) ->
    event = new Event req.body
    event.save (err, event) ->
      if not err
        res.redirect '/events'
      else
        res.statusCode = 500
        res.render 'events/form', event: event
  , () ->
    res.statusCode = 403
    res.redirect '/'

exports.edit = (req, res) ->
  Event.findById req.params.id, (err, event) ->
    res.render 'events/form', event: event

exports.update = (req, res) ->
  Event.findByIdAndUpdate req.params.id, {"$set":req.body}, (err, event) ->
    if not err
      res.redirect '/events'
    else
      console.log err
      res.statusCode = 500
      res.render 'events/form', event: event

exports.delete = (req, res) ->
  Event.findByIdAndRemove req.params.id, (err) ->
    res.redirect '/events'
