class SnippetEffect

  start: ($domNode) ->
    throw 'Must implement "start" function for Effect subclass'


class @Slideshow extends SnippetEffect

  constructor: (@snippet, @overrideConfig) ->

  start: ($domNode) ->
    config =
      wordDelay: 300
      sourceDelay: 1000

    jQuery.extend config, @overrideConfig
    words = @snippet.text.split(" ", 100)
    source = @snippet.source
    i = 0
    interval = 0
    $header = jQuery("<h2>" + @snippet.type + "</h2>")
    $paragraph = undefined
    if @snippet.href?
      $paragraph = jQuery("<a href=\"" + @snippet.href + "\"><span></span></a>")
    else
      $paragraph = jQuery("<p><span></span></p>")
    $domNode.append $header
    $domNode.append $paragraph
    interval = Meteor.setInterval(->
      nextWord = words[i++]
      $paragraph.find("span").append nextWord + ((if i > 0 then " " else ""))
      if i is words.length
        Meteor.clearInterval interval
        Meteor.setTimeout (->
          $domNode.append "<p><a href=\"" + source + "\">" + source + "</a></p>"
        ), config.sourceDelay
    , config.wordDelay)



class @AllAtOnce extends SnippetEffect

  constructor: (@snippet, @overrideConfig) ->

  start: ($domNode) ->
    config = {}
    jQuery.extend config, @overrideConfig
    words = @snippet.text
    source = @snippet.source
    $domNode.append "<p>" + words + "</p>"
    $domNode.append "<p><a href=\"" + source + "\">" + source + "</a></p>"



class @Ticker extends SnippetEffect
  

  constructor: (@snippet, @overrideConfig) ->


  start: ($domNode) ->
    
    config =
      charDelay: 100
      sourceDelay: 1000

    jQuery.extend config, @overrideConfig
    text = @snippet.text
    source = @snippet.source
    i = 0
    interval = 0
    $header = jQuery("<h2>" + @snippet.type + "</h2>")
    $paragraph = undefined
    
    if @snippet.href?
      $paragraph = jQuery("<a href=\"" + @snippet.href + "\"><span></span></a>")
    else
      $paragraph = jQuery("<p><span></span></p>")

    $domNode.append $header
    $domNode.append $paragraph
    interval = Meteor.setInterval(->
      nextChar = text[i++]
      $paragraph.find("span").append nextChar
      if i is source.length
        Meteor.clearInterval interval
        Meteor.setTimeout (->
          $domNode.append "<p><a href=\"" + source + "\">" + source + "</a></p>"
        ), config.sourceDelay
    , config.charDelay)