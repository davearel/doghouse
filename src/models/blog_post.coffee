mongoose = require 'mongoose'
User = require '../models/user'

# Blog model
BlogPost = new mongoose.Schema(
  name: String
  description: String
  created_at: {type: Date, default: Date.now}
  _created_by: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User'}
  created_by: {type : {}}
  votes : []
)

module.exports = mongoose.model 'BlogPost', BlogPost