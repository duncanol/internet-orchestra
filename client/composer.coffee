class @Composer 

  constructor: -> 


  compose: (conductor) ->
    _this = this
    @conductor = conductor

    Meteor.setInterval (-> 
      _this.refreshPane()
    ), 120000

    @refreshPane()


  refreshPane: ->
    if @currentPane?  
      @currentPane.stop()
      Meteor.clearTimeout @currentPane.timeout

    @currentPane = @randomPane().call(@)
    @currentPane.start()


  flashwords: ->
    _this = this
    pane = new RollingPane(domParent: "div.main-container", numberOfItems: 1)
    steadyBeat = (Math.random() * 3000) + 1000
    rollingPaneAdd = (timeout) ->
      pane.timeout = Meteor.setTimeout (->
        Meteor.call "getSnippet", (errors, snippet) ->
          words = snippet.text.split(" ")
          randomWord = words[Math.floor Math.random() * words.length]
          snippet.text = randomWord
          effect = _this.allAtOnceEffect(snippet,
            template: Template.minimalisteffectblock)
          _this.conductor.conduct pane, effect, 0
          rollingPaneAdd steadyBeat

      ), timeout

    rollingPaneAdd 0
    pane

  rollingPane: ->
    _this = this
    pane = new RollingPane(domParent: "div.main-container")
    rollingPaneAdd = (timeout) ->
      pane.timeout = Meteor.setTimeout (->
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
      pane.timeout = Meteor.setTimeout (->
        Meteor.call "getSnippet", (errors, snippet) ->
          effect = _this.randomEffect()(snippet)
          _this.conductor.conduct pane, effect, 0
          gridPaneAdd Math.round(Math.random() * 10000)

      ), timeout

    gridPaneAdd 0
    pane


  slideshowEffect: (snippet, overrideConfig) ->
    config =
      wordDelay: Math.round(Math.random() * 300)
      sourceDelay: Math.round(Math.random() * 1000)

    jQuery.extend config, overrideConfig
    
    new Slideshow snippet, config

  tickerEffect: (snippet, overrideConfig) ->
    config =
      charDelay: Math.round(Math.random() * 100)
      sourceDelay: Math.round(Math.random() * 1000)

    jQuery.extend config, overrideConfig
    
    new Ticker snippet, config

  allAtOnceEffect: (snippet, overrideConfig) ->
    new AllAtOnce snippet, overrideConfig

  randomPane: ->
    paneFunctions = [@flashwords] 
    #@gridPane, @rollingPane
    random = Math.floor(Math.random() * paneFunctions.length)
    paneFunctions[random]

  randomEffect: ->
    effectsFunctions = [@slideshowEffect, @allAtOnceEffect, @tickerEffect]
    random = Math.floor(Math.random() * effectsFunctions.length)
    effectsFunctions[random]