# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  $(".songbox").on "click", ->
    othersong = undefined
    song = undefined
    song = $(this).find(".song")
    othersong = $(".song").not(song)
    if $(this).hasClass("playing")
      song.trigger "pause"
      $(this).removeClass "playing"
    else
      $(this).addClass "playing"
      song.trigger "play"
      othersong.trigger "pause"
      $(othersong).closest('.songbox').removeClass "playing"
    $(song).on "ended", ->
      $(song).closest(".songbox").removeClass "playing"
      return

    return

  return

$(document).ready(ready)
$(document).on('page:load', ready)