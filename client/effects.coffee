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
    
    fragment = Template.effectblock(
      @snippet
      )

    $domNode.append fragment
    $paragraph = $domNode.find '.snippet-block-paragraph'

    i = 0
    interval = Meteor.setInterval(->
      nextWord = words[i++]
      $paragraph.append nextWord + ((if i > 0 then " " else ""))
      if i is words.length
        Meteor.clearInterval interval
        Meteor.setTimeout (->
          $anchor = $domNode.find '.snippet-block-source-url' 
          $anchor.attr('href', source)
          $anchor.text source
        ), config.sourceDelay
    , config.wordDelay)



class @AllAtOnce extends SnippetEffect

  constructor: (@snippet, @overrideConfig) ->

  start: ($domNode) ->
    config = {}
    jQuery.extend config, @overrideConfig
    type = @snippet.type
    words = @snippet.text
    source = @snippet.source
    $domNode.append "<h2>" + type + "</h2>"
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
    $header = jQuery("<h2>" + @snippet.type + "</h2>")
    $paragraph = undefined
    
    $paragraph = if @snippet.href?
      jQuery("<a href=\"" + @snippet.href + "\"><span></span></a>")
    else
      jQuery("<p><span></span></p>")

    $domNode.append $header
    $domNode.append $paragraph
    
    i = 0
    interval = Meteor.setInterval(->
      nextChar = text[i++]
      $paragraph.find("span").append nextChar
      if i is source.length
        Meteor.clearInterval interval
        Meteor.setTimeout (->
          $domNode.append "<p><a href=\"" + source + "\">" + source + "</a></p>"
        ), config.sourceDelay
    , config.charDelay)