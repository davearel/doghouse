$ ->
  $('.datepicker').datepicker(format: 'mm/dd/yyyy')


  $('.confirm-delete').bind 'click', (e) ->
    r = confirm("Are you sure?")
    e.preventDefault() unless r == true