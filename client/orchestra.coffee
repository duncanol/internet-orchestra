class @Orchestra
  constructor: (@composer, @conductor) ->

  start: ->
    @composer.compose @conductor