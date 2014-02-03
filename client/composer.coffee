class @Composer 

  constructor: -> 

  compose: (conductor) ->
    _this = this
    @conductor = conductor
    rollingPane = @rollingPane()
    Meteor.setTimeout (->
      gridPane = _this.gridPane()
      rollingPane.stop()
    ), 10000

  rollingPane: ->
    _this = this
    pane = new RollingPane(domParent: "div.main-container")
    pane.start()
    rollingPaneAdd = (timeout) ->
      Meteor.setTimeout (->
        Meteor.call "getSnippet", (errors, snippet) ->
          effect = _this.slideshowEffect(snippet)
          _this.conductor.conduct pane, effect, 0
          rollingPaneAdd Math.round(Math.random() * 5000)

      ), timeout

    rollingPaneAdd 0
    Meteor.call "getSnippet", (errors, snippet) ->
      effect = _this.allAtOnceEffect(snippet)
      self.conductor.conduct pane, effect, 1000

    pane

  gridPane: ->
    _this = this
    pane = new GridPane(domParent: "div.main-container")
    pane.start()
    gridPaneAdd = (timeout) ->
      Meteor.setTimeout (->
        Meteor.call "getSnippet", (errors, snippet) ->
          effect = _this.slideshowEffect(snippet)
          _this.conductor.conduct pane, effect, 0
          gridPaneAdd Math.round(Math.random() * 10000)

      ), timeout

    gridPaneAdd 0
    pane

  slideshowEffect: (snippet) ->
    new Slideshow snippet,
      wordDelay: Math.round(Math.random() * 300)
      sourceDelay: Math.round(Math.random() * 1000)


  allAtOnceEffect: (snippet) ->
    new AllAtOnce(snippet)