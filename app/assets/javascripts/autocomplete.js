$(document).ready(function() {
  $( "#query, #new_chwink" ).autocomplete({
    minLength: 2,
    source: function( request, response ) {
      var postData = {
          "query": { 
            "bool": {
              "should": [{"query_string": {"query": "name.autocomplete:"+request.term}},
                      {"query_string": {"query": "description:"+request.term}}]
            } 
          },
      };
      console.log(request.term);
      $.ajax({
        url: "http://"+ window.location.hostname +":9200/chwink_development/chwink/_search",
        type: "POST",
        dataType: "json",
        data: JSON.stringify(postData),
        success: function( data ) {
          response( $.map( data.hits.hits, function( item ) {
            return {
              label: item._source.name,
              value: item._source.name
            }   
          }));
        }
      });
    },
    messages: {
      noResults:'' ,
      results: function() {}
    }
  });
});





