/*  $("#search").typeahead({                                

    source: [ "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune" ],
    items: 3                                                                   
    //var text = $('#search').val(); 
    
    var search_data ={
     
        "query": {"query_string": {"query": "name.autocomplete:" + $('#search').val()}},
        "size": 3
     
    };
    
    source: function(query,process){
      return $.ajax({
        url: 'http://localhost:9200/chwink_development/chwink/_search',
        type: 'GET',
        crossDomain: true,
        //contentType: 'application/json; charset=UTF-8',
        //success: function(data) { console.log(data) }
        dataType: 'json',
        data: JSON.stringify(search_data),
        success: function(data){
          alert(data);
        }
      });
      //var jsonData = jQuery.parseJSON(json.responseText);
    }
    

      
  });
*/


$(document).ready(function() {
  $( "#trial" ).autocomplete({
    source: function( request, response ) {
      var postData = {
        "query": {"query_string" : { "q": "name.autocomplete:"+request.term }}
      };
      console.log(JSON.stringify(postData));
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





