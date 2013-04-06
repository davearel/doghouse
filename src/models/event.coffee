mongoose = require 'mongoose'
User = require '../models/user'
dateFormat = require 'dateformat'


# Event model
Event = new mongoose.Schema(
  name: {type: String, required: true}
  uri: {type: String, required: true}
  when_at: {type: Date, required: true}
  notes: {type: String}
  created:  {type: Date, default: Date.now}
  created_by: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User'}
  voters: [{type: mongoose.Schema.Types.ObjectId, ref: 'User'}]
)

Event.path('uri').validate (value) ->
  return /^https?:\/\//.test(value)
, 'invalid URI'

Event.virtual('when_at_datepicker_format').get ->
  console.log this.when_at
  if this.when_at
    dateFormat(this.when_at, "mm/dd/yyyy");

module.exports = mongoose.model 'Event', Event