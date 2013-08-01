String::repeat = (num) ->
  new Array(num + 1).join @

(($) ->
  $ ->
    # Custom Select
    $("select").selectpicker
      style: "btn-primary"
      menuStyle: "dropdown-inverse"
    
    # Placeholders for input/textarea
    $("input, textarea").placeholder()

    $(".btn-group a").on "click", ->
      $(@).siblings().removeClass("active").end().addClass "active"

    # Disable link clicks to prevent page scrolling
    $("a[href=\"#fakelink\"]").on "click", (e) ->
      e.preventDefault()

) jQuery