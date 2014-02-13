class @Composer 

  constructor: -> 


  compose: (conductor) ->
    _this = this
    @conductor = conductor

    playNextComposition = ->
      composition = _this.randomPane().call(_this)
      conductor.conduct(composition, playNextComposition)    

    playNextComposition()


  flashwords: ->

    _this = @
    
    tempo = ((Math.random() * 1000) + 1000)
      
    notePatterns = [{name: '4 beats', pattern: [1/4, 1/4, 1/4, 1/4]}]
    
    composition = new Composition(
      name: "flashwords", 
      tempo: tempo,
      transitionSmoothness: 'not yet implemented')

    numberOfSections = 2

    for sectionIndex in [1..numberOfSections] 

      notePattern = notePatterns[0]

      pane = new RollingPane(
        domParent: "div.main-container", 
        numberOfItems: 1)

      section = new Section(
        pane: pane, 
        tempo: tempo,
        notePattern: notePattern.name)

      barLength = 4
      barLengthMillis = Math.floor(barLength * section.tempo)
      
      for noteIndex in [0...notePattern.pattern.length]
        getEffect = (getEffectCallback) -> 
          Meteor.call "getSnippet", (errors, snippet) ->
            words = snippet.text.split(" ")
            randomWord = words[Math.floor Math.random() * words.length]
            snippet.text = randomWord
            effect = new AllAtOnce(snippet,
              template: Template.minimalisteffectblock)
            getEffectCallback(effect)

        note = new Note(
          getEffect: getEffect, 
          length: notePattern.pattern[noteIndex] * barLengthMillis)
        
        section.addNote(note)

      composition.addSection(section)
    
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