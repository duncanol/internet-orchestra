class Pane

class @RollingPane extends Pane 

  constructor: (overrideConfig) ->
    @config =
      numberOfItems: 5
      domParent: "body"

    jQuery.extend @config, overrideConfig
    @$domParent = jQuery(@config.domParent)
    @$paneDiv = jQuery("<div class=\"rolling-pane row\"></div>")
    @$paneList = jQuery("<ul class=\"rolling-pane-list snippet-block span12\"></ul>")
    @$paneList.appendTo @$paneDiv

  start: ->
    @$paneDiv.appendTo @$domParent

  stop: ->
    @$paneDiv.remove()

  addEffect: (effect) ->
    $listItems = @$paneList.find("li")
    $listItems[0].remove()  if $listItems.length is @config.numberOfItems
    $snippetContainer = jQuery("<li class=\"well\"></li>")
    $snippetContainer.appendTo @$paneList
    effect.start $snippetContainer

class @GridPane extends Pane

  constructor: (overrideConfig) ->
    @config =
      width: 4
      height: 4
      domParent: "body"

    jQuery.extend @config, overrideConfig
    @$domParent = jQuery(@config.domParent)
    @$paneDiv = jQuery("<div class=\"grid-pane\"></div>")

    addSummat = ->
      $paneRow = jQuery("<div class=\"row\"></div>")
      x = 0

      while x < @config.width
        $paneRow.append "<div class=\"grid-pane-cell grid-pane-cell-empty snippet-block well span" + Math.round(12 / @config.width) + "\"></div>"
        x++
      @$paneDiv.append $paneRow

    y = 0

    while y < @config.height
      $paneRow = jQuery("<div class=\"row\"></div>")
      x = 0

      while x < @config.width
        $paneRow.append "<div class=\"grid-pane-cell grid-pane-cell-empty snippet-block well span" + Math.round(12 / @config.width) + "\"></div>"
        x++
      @$paneDiv.append $paneRow
      y++

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