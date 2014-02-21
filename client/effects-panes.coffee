class Pane



class @RollingPane extends Pane 

  constructor: (overrideConfig) ->
    @config =
      numberOfItems: 5
      domParent: "body"
      feedStrategy: 'from-bottom'

    jQuery.extend @config, overrideConfig

    @$domParent = jQuery(@config.domParent)
    @$paneDiv = jQuery("<div class=\"rolling-pane row\"></div>")
    @$paneList = jQuery("<ul class=\"rolling-pane-list snippet-block span12\"></ul>")
    @$paneList.appendTo @$paneDiv

  start: ->
    @$paneDiv.appendTo @$domParent

  stop: ->
    @$paneDiv.remove()

  addEffect: (effect, length, finishedEffectCallback) ->
    $listItems = @$paneList.find("li")
    $snippetContainer = jQuery("<li class=\"well\"></li>")

    if $listItems.length is @config.numberOfItems
      switch @config.feedStrategy
        when 'from-top'
          $listItems[0].remove()
        when 'from-bottom'
          $listItems[$listItems.length - 1].remove()
      
    switch @config.feedStrategy
      when 'from-top'
        $snippetContainer.prependTo @$paneList
      when 'from-bottom'
        $snippetContainer.appendTo @$paneList
    

    effect.start $snippetContainer, length, finishedEffectCallback



class @GridPane extends Pane

  constructor: (overrideConfig) ->
    @config =
      width: 4
      height: 4
      domParent: "body"

    jQuery.extend @config, overrideConfig
    @$domParent = jQuery(@config.domParent)
    @$paneDiv = jQuery("<div class=\"grid-pane\"></div>")

    y = 0
    while y++ < @config.height
      $paneRow = jQuery("<div class=\"row\"></div>")
      @$paneDiv.append $paneRow
      
      x = 0
      while x++ < @config.width
        $paneRow.append "<div class=\"grid-pane-cell grid-pane-cell-empty snippet-block well span" + Math.round(12 / @config.width) + "\"></div>"
        

  start: ->
    @$paneDiv.appendTo @$domParent

  stop: ->
    @$paneDiv.remove()

  addEffect: (effect) ->
    $listItems = @$paneDiv.find(".grid-pane-cell-empty")
    $listItems = @$paneDiv.find(".grid-pane-cell")  if $listItems.length is 0
    $listItem = jQuery($listItems[Math.round(Math.random() * $listItems.length)])
    $snippetContainer = jQuery("<span></span>")
    $listItem.html $snippetContainer
    $listItem.removeClass "grid-pane-cell-empty"
    effect.start $snippetContainer