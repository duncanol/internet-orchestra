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
    
    $domNode.append Template.effectblock @snippet
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
    $domNode.append Template.effectblock @snippet
    
    $paragraph = $domNode.find '.snippet-block-paragraph'
    $paragraph.append @snippet.text

    $anchor = $domNode.find '.snippet-block-source-url' 
    $anchor.attr('href', @snippet.source)
    $anchor.text @snippet.source


class @Ticker extends SnippetEffect
  

  constructor: (@snippet, @overrideConfig) ->


  start: ($domNode) ->
    
    config =
      charDelay: 100
      sourceDelay: 1000

    jQuery.extend config, @overrideConfig
    text = @snippet.text
    source = @snippet.source

    $domNode.append Template.effectblock @snippet
    $paragraph = $domNode.find '.snippet-block-paragraph'
    
    i = 0
    interval = Meteor.setInterval(->
      nextChar = text[i++]
      $paragraph.append nextChar
      if i is text.length
        Meteor.clearInterval interval
        Meteor.setTimeout (->
          $anchor = $domNode.find '.snippet-block-source-url' 
          $anchor.attr('href', source)
          $anchor.text source
        ), config.sourceDelay
    , config.charDelay)