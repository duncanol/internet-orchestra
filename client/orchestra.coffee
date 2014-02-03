class @Orchestra
  constructor: (@composer, @conductor) ->

Orchestra::start = ->
  @composer.compose @conductor