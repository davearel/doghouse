#= require_tree js

jQuery ->
  for link in $(".navbar .nav li a")
    do (link) ->
      if (window.location.pathname == link.pathname)
        $(link).parent().toggleClass("active")