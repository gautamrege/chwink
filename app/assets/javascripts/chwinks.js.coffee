# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $.ajax
    url: '/get_recent_activity'
    success: (data) ->
      console.log("Recent Activity")
      console.log(data)
      unless data["recent_activity"]["data"].length is 0
        $.each data["recent_activity"]["data"], (index, recent_actv) ->
          $("#messagewindow").append "<li class='activity'>" + recent_actv.message + "</li>"
  $('.chwink-comment').live 'click', -> 
    $('#new_comment').attr('action','/chwinks/'+$(this).attr('id')+'/comment')
  $('#add_comment').live 'click', -> 
    $('#new_comment').submit()
  $('#new_comment').on 'ajax:success', (event, data, status, xhr) ->
    $('#chwink_comment').modal('hide')
    user_image =  "<img width='16px' height ='16px' class='user_image' src= "+ data.profile_image + " />"
    message =  "<li class='activity'>" + user_image + " " +data.nickname + " commented on chiwnk " + "<a href = /chwinks/" + data.chwink_id + ">" + data.chwink_name + "</a> </li>"
    client.publish "/activity/public",
      message: message
    console.log(data)
    
  
 
