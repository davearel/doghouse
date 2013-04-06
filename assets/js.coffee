#= require js/app

#= require_tree js/models/
#= require_tree js/collections/
#= require_tree js/controllers/

#= require_tree js/templates/
#= require_tree js/view_models/
#= require_tree js/views/

# Decide what controller use based on URL root
switch PATH_ROOT
  
  when 'issues'
    new App.Controller.Issues()