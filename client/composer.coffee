class @Composer 

  constructor: -> 


  compose: (conductor) ->
    _this = this
    @conductor = conductor

    
    # Meteor.setInterval refreshPane 60000

    @refreshPane()

  refreshPane: ->
    if @currentPane? then @currentPane.stop
    @currentPane = @randomPane().call(@)
    @currentPane.start()


  rollingPane: ->
    _this = this
    pane = new RollingPane(domParent: "div.main-container")
    rollingPaneAdd = (timeout) ->
      Meteor.setTimeout (->
        Meteor.call "getSnippet", (errors, snippet) ->
          effect = _this.randomEffect()(snippet)
          _this.conductor.conduct pane, effect, 0
          rollingPaneAdd Math.round(Math.random() * 5000)

      ), timeout

    rollingPaneAdd 0
    pane


  gridPane: ->
    _this = this
    pane = new GridPane(domParent: "div.main-container")
    gridPaneAdd = (timeout) ->
      Meteor.setTimeout (->
        Meteor.call "getSnippet", (errors, snippet) ->
          effect = _this.randomEffect()(snippet)
          _this.conductor.conduct pane, effect, 0
          gridPaneAdd Math.round(Math.random() * 10000)

      ), timeout

    gridPaneAdd 0
    pane


  slideshowEffect: (snippet) ->
    new Slideshow snippet,
      wordDelay: Math.round(Math.random() * 300)
      sourceDelay: Math.round(Math.random() * 1000)

  tickerEffect: (snippet) ->
    new Ticker snippet,
      charDelay: Math.round(Math.random() * 100)
      sourceDelay: Math.round(Math.random() * 1000)

  allAtOnceEffect: (snippet) ->
    new AllAtOnce(snippet)

  randomPane: ->
    paneFunctions = [@gridPane, @rollingPane]
    random = Math.floor(Math.random() * paneFunctions.length)
    paneFunctions[random]

  randomEffect: ->
    effectsFunctions = [@slideshowEffect, @tickerEffect, @allAtOnceEffect]
    random = Math.floor(Math.random() * effectsFunctions.length)
    effectsFunctions[random]