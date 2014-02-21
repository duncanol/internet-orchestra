class SnippetEffect

  start: ($domNode) ->
    throw 'Must implement "start" function for Effect subclass'


class @Slideshow extends SnippetEffect

  constructor: (@snippet, @overrideConfig) ->

  start: ($domNode, length, finishedEffectCallback) ->
    config =
      wordDelay: 300
      sourceDelay: 1000
    
    words = @snippet.text.split(" ", 100)
    source = @snippet.source

    if (length?)
      config.wordDelay = length / (words.length + 1)
      config.sourceDelay = config.wordDelay

    
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

          finishedEffectCallback()
        ), config.sourceDelay
    , config.wordDelay)



class @AllAtOnce extends SnippetEffect

  constructor: (@snippet, @overrideConfig) ->

  start: ($domNode, length, finishedEffectCallback) ->
    config = 
      template: Template.effectblock
      delay: 0

    jQuery.extend config, @overrideConfig

    if (length?)
      config.delay = length
    
    $domNode.append config.template @snippet
    
    $paragraph = $domNode.find '.snippet-block-paragraph'
    $paragraph.append @snippet.text

    $anchor = $domNode.find '.snippet-block-source-url'
    if ($anchor.length > 0) 
      $anchor.attr('href', @snippet.source)
      $anchor.text @snippet.source

    Meteor.setTimeout(->
      finishedEffectCallback()
    , config.delay)


class @Ticker extends SnippetEffect
  

  constructor: (@snippet, @overrideConfig) ->


  start: ($domNode, length, finishedEffectCallback) ->
    
    config =
      charDelay: 100
      sourceDelay: 1000

    jQuery.extend config, @overrideConfig

    text = @snippet.text
    source = @snippet.source

    if (length?)
      config.charDelay = length / (text.length + 1)
      config.sourceDelay = config.charDelay

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

          finishedEffectCallback()
        ), config.sourceDelay
    , config.charDelay)