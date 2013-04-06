mongoose = require 'mongoose'
User = require '../models/user'

# Event model
Event = new mongoose.Schema(
  name: String
  when_at: Date
  notes: String
  created:  {type: Date, default: Date.now}
  created_by: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User'}
  voters: [{type: mongoose.Schema.Types.ObjectId, ref: 'User'}]
)

module.exports = mongoose.model 'Event', Event