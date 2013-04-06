User = require '../models/user'

exports.do = (req, success_callback, failure_callback) ->
  if req.session and req.session.user_id 
    User.findById req.session.user_id, (err, user) ->
      if user
        success_callback user
        return
     
      failure_callback null

  else
    failure_callback null
