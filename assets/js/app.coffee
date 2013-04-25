# App stores our application
# logic in namespaced objects
window.App =
  Github: {}
  github: {}
  Controller: {}
  View: {}

# extend our app object to handle backbone events
_.extend( App, Backbone.Events )

# Avoid `console` errors in browsers that lack a console.
(->
  method = undefined
  noop = ->

  methods = ["assert", "clear", "count", "debug", "dir", "dirxml", "error", "exception", "group", "groupCollapsed", "groupEnd", "info", "log", "markTimeline", "profile", "profileEnd", "table", "time", "timeEnd", "timeStamp", "trace", "warn"]
  length = methods.length
  console = (window.console = window.console or {})
  while length--
    method = methods[length]
    
    # Only stub undefined methods.
    console[method] = noop  unless console[method]
)()