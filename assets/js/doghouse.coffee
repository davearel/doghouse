#= require app

#= require_tree models
#= require_tree collections
#= require_tree controllers

#= require_tree templates
#= require_tree view_models
#= require_tree views

# Decide what controller use based on URL path
switch document.location.pathname
  
  when '/issues'
    new App.Controller.Issues()
