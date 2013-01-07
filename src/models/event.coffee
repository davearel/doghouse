mongoose = require 'mongoose'

# Event model
Event = new mongoose.Schema(
  name: String
  when_at: Date
  notes: String
  created:  {type: Date, default: Date.now}
)

module.exports = mongoose.model 'Event', Event