jQuery ($) ->
  # you'll probably want to remove the left styles from the css for ".lower-tag-1 thru 4"

  # new year
  $(document).on "click",".btn-new-year", ->
    $(".vote-year-input, .vote-year-submit").fadeIn("slow")

  $(document).on "click",".btn-submit-year", ->
    $.ajax "/chwinks/#{$(this).closest(".vote-col").attr('id')}/vote/#{$(this).parent().parent().find('input').val()}",
      type: 'GET',
      success: (data) ->
        $(".new-year .span").hide()
        $(".new-year").html("<h5>thank you for voting</h5>")

  $(document).on "click",".check", ->
    $.ajax "/chwinks/#{$(this).closest(".vote-col").attr('id')}/vote/#{$(this).data().year}",
      type: 'GET'
