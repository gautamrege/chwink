jQuery ($) ->
  # you'll probably want to remove the left styles from the css for ".lower-tag-1 thru 4"

  # new year
  $(".btn-new-year").on "click", ->
    $(".vote-year-input, .vote-year-submit").fadeIn("slow")

  $(".btn-submit-year").on "click", ->
    $.ajax "/chwinks/#{$(this).closest(".vote-col").attr('id')}/vote/#{$(this).parent().parent().find('input').val()}",
      type: 'GET',
      success: (data) ->
        $(".new-year .span").hide()
        $(".new-year").html("<h5>thank you for voting</h5>")

  $(".check").on "click", ->
    $.ajax "/chwinks/#{$(this).closest(".vote-col").attr('id')}/vote/#{$(this).data().year}",
      type: 'GET'
