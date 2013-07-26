$(document).ready(function() {
  $( "#query, #new_chwink" ).autocomplete({
    source: function( request, response ) {
      var postData = {
        "query": {"query_string" : { "q": "name.autocomplete:"+request.term }}
      };
      $.ajax({
        url: "http://localhost:9200/chwink_development/chwink/_search?q=name.autocomplete:"+request.term,
        //url: "http://localhost:9200/chwink_development/chwink/_search?",
        dataType: "jsonp",
        //data: JSON.stringify(postData),
        //contentType: 'application/json; charset=UTF-8',
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
  minLength: 2,
  });
});





