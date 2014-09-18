# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $(".record-label").on "click", ->
    if $(this).hasClass("paused")
      $("#themesong").trigger "play"
      $(this).addClass "fa-spin"
      $(this).removeClass "paused"
    else
      $("#themesong").trigger "pause"
      $(".song").trigger "pause"
      $(".songbox").removeClass "playing"
      $(this).addClass "paused"
    $("#themesong").on "ended", ->
    	$(".record-label").addClass "paused"

    return
  $(".songbox").on "click", ->
    song = $(this).find(".song")
    othersong = $(".song").not(song)
    themesong = $("#themesong")
    if $(this).hasClass("playing")
      song.trigger "pause"
      $(this).removeClass "playing"
      $(".record-label").addClass "paused"
    else
      $(this).addClass "playing"
      $(".record-label").addClass "fa-spin"
      $(".record-label").removeClass "paused"
      song.trigger "play"
      othersong.trigger "pause"
      themesong.trigger "pause"
      $(othersong).closest('.songbox').removeClass "playing"
    $(song).on "ended", ->
      $(song).closest(".songbox").removeClass "playing"
      $(".record-label").addClass "paused"
      
      return

    return

  return

$(document).ready(ready)
$(document).on('page:load', ready)