class @Composer 

  constructor: -> 


  compose: (conductor) ->
    _this = this
    @conductor = conductor

    playNextComposition = ->
      composition = _this.randomPane().call(_this, (composition) ->
        conductor.conduct(composition, playNextComposition)    
      )

    playNextComposition()


  flashwords: (finishedBuildingCompositionCallback) ->

    _this = @

    
    buildNotes = (notePattern, section, barLengthMillis, async, finishedBuildingNotesCallback) ->
      
      [thisNote, remainingNotes] = headTail(notePattern)

      if (thisNote == null)
        finishedBuildingNotesCallback()
      else

        asyncEffect = (effectCreatedCallback) ->
          Meteor.call "getSnippet", (errors, snippet) ->
            words = snippet.text.split(" ")
            randomWord = words[Math.floor Math.random() * words.length]
            snippet.text = randomWord
            effect = new AllAtOnce(snippet,
              template: Template.minimalisteffectblock)
            effectCreatedCallback(effect)
        
        addNoteAndContinue = (effect, async) ->
          if (async)
            note = new Note(
              asyncEffect: effect, 
              length: thisNote * barLengthMillis)
          else 
            note = new Note(
              effect: effect, 
              length: thisNote * barLengthMillis)
          
          section.addNote(note)
          buildNotes remainingNotes, section, barLengthMillis, async, finishedBuildingNotesCallback
          

        if (async)
          addNoteAndContinue asyncEffect, async
        else 
          asyncEffect((effect) -> 
            addNoteAndContinue effect, async
          )
          



    buildSections = (remainingSections, finishedBuildingSectionsCallback) ->

      if (remainingSections == 0) 
        finishedBuildingSectionsCallback()
      else 
        notePattern = notePatterns[0]

        pane = new RollingPane(
          domParent: "div.main-container", 
          numberOfItems: 1)

        section = new Section(
          pane: pane, 
          tempo: tempo,
          notePattern: notePattern.name)

        composition.addSection(section)
        
        barLength = 4
        barLengthMillis = Math.floor(barLength * section.tempo)

        buildNotes notePattern.pattern, section, barLengthMillis, false, ->
          buildSections remainingSections - 1, finishedBuildingSectionsCallback


    tempo = ((Math.random() * 1000) + 1000)
      
    notePatterns = [{name: '4 beats', pattern: [1/4, 1/4, 1/4, 1/4]}]
    
    composition = new Composition(
      name: "flashwords", 
      tempo: tempo,
      transitionSmoothness: 'not yet implemented')

    numberOfSections = 16

    buildSections numberOfSections, ->
      finishedBuildingCompositionCallback(composition)



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