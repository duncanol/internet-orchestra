class @Composer 

  constructor: -> 


  compose: (conductor) ->
    _this = this
    @conductor = conductor

    playNextComposition = ->
      composition = _this.randomPane().call(_this)    
      composition.play(playNextComposition)

    playNextComposition()


  flashwords: ->

    _this = @
    
    composition = new Composition(
      name: "flashwords", 
      tempo: 'not yet implemented',
      transitionSmoothness: 'not yet implemented')

    pane = new RollingPane(
      domParent: "div.main-container", 
      numberOfItems: 1)

    steadyBeat = (Math.random() * 3000) + 1000
    
    section = new Section(
      pane: pane, 
      tempo: 'not yet implemented')
    
    composition.addSection(section)

    sectionLength = (Math.random() * 48) + 16
    for i in [1..sectionLength]
      noteFunction = -> 
        Meteor.call "getSnippet", (errors, snippet) ->
          words = snippet.text.split(" ")
          randomWord = words[Math.floor Math.random() * words.length]
          snippet.text = randomWord
          effect = new AllAtOnce(snippet,
            template: Template.minimalisteffectblock)
          _this.conductor.conduct pane, effect

      note = new Note(
        noteFunction: noteFunction, 
        length: steadyBeat)
      
      section.addNote(note)
    
    composition



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
          _this.conductor.conduct pane, effect
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
    ##, @gridPane, @rollingPane] 
    random = Math.floor(Math.random() * paneFunctions.length)
    paneFunctions[random]

  randomEffect: ->
    effectsFunctions = [@slideshowEffect, @allAtOnceEffect, @tickerEffect]
    random = Math.floor(Math.random() * effectsFunctions.length)
    effectsFunctions[random]