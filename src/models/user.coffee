mongoose = require 'mongoose'

# User model (comes from GitHub)
User = new mongoose.Schema(
  name: String
  github_id: String
  login: String
  access_token: String
  created:  {type: Date, default: Date.now}
)

module.exports = mongoose.model 'User', User