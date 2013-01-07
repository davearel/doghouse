# 
exports.index = (req, res) ->
  res.render 'events/index'

exports.add = (req, res) ->
  res.render 'events/add'
