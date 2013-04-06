fs = require 'fs'

# so we only need to load the data the first time the module is used
settings_cache = null

exports.get = (key, callback) -> 
  settings_cache[key]

# load the user_events definitions
load_settings = () ->
  console.log 'loading and parsing application settings'
  settings_cache = JSON.parse(fs.readFileSync(process.cwd() + '/settings.json'))

load_settings()