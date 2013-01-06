# 
exports.logout = (req, res) ->
  req.session = {}
  res.redirect '/'
