class @Orchestra
  constructor: (@composer, @conductor) ->

  start: ->
    @composer.compose @conductor

  pause: ->
    @conductor.pause()

  stop: ->
    @conductor.stop()