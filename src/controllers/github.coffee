request = require 'request'
 
exports.callback = (req, res) ->
  request_data =
    url: 'https://github.com/login/oauth/access_token',
    json: true
    body: {
      "client_id": res.locals.config.GITHUB_CLIENT_ID,
      "client_secret": res.locals.config.GITHUB_SECRET,
      "code": req.query.code
    }
  request.post request_data, (e, r, b) ->
    response = r
    req.session.access_token = response.body.access_token
    res.redirect '/'
