#= require app

#= require_tree models
#= require_tree collections
#= require_tree controllers

#= require_tree templates
#= require_tree views
#= require router

App.controller = {}
App.router = new App.Router()
Backbone.history.start({pushState: true})
