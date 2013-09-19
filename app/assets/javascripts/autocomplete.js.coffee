$(document).ready ->
  $("#query, #new_chwink").autocomplete
    minLength: 2
    messages:
      noResults: ""
      results: ->

    source: (request, response) ->
      
      #console.log(request.term);
      $.ajax
        url: "chwinks/autocomplete"
        type: "POST"
        dataType: "json"
        data: request.term
        success: (data) ->
          response $.map(data, (item) ->
            label: item.name
            value: item.name
          )


