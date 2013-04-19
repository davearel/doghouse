Event = require '../models/event'
current_user = require '../lib/current_user'

exports.index = (req, res) ->
  Event.find({}).populate('created_by').exec (err, events) ->
    res.render 'events/index',  events: events

exports.new = (req, res) ->
  event = new Event
  res.render 'events/form', event: event, error: null

exports.create = (req, res) ->

  # with the current user
  current_user.do req, (user) ->

    # create a new event model
    event = new Event req.body
    event.created_by = user

    event.save (error) ->
      if not error
        res.redirect '/events'
      else
        res.statusCode = 500
        res.render 'events/form', event: event, error: error
  
  # user not signed in
  , () ->
    res.statusCode = 403
    res.redirect '/'

exports.edit = (req, res) ->
  Event.findById req.params.id, (err, event) ->
    res.render 'events/form', event: event, error: null

exports.update = (req, res) ->
  Event.findByIdAndUpdate req.params.id, {"$set":req.body}, (error) ->
    if not error
      res.redirect '/events'
    else
      res.statusCode = 500
      res.render 'events/form', event: event, error: error

exports.delete = (req, res) ->
  Event.findByIdAndRemove req.params.id, (err) ->
    res.redirect '/events'
