exports.index = (req, res) ->
  res.render 'tools/index', page: 'getting_started'

exports.signatures = (req, res) ->
  res.render 'tools/signatures', page: 'signatures'

exports.chrome = (req, res) ->
  res.render 'tools/chrome', page: 'chrome'

exports.merchant_guidelines = (req, res) ->
  res.render 'tools/merchant_guidelines', page: 'merchant_guidelines'