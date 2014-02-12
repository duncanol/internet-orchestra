headTail = (array) ->
  if (array.length == 0) 
    [null, Array()]
  else if (array.length == 1) 
    [array[0], Array()]
  else 
    [array[0], array[1..array.length - 1]]
  

class @Composition
  
  constructor: (config) ->
    @name = config.name
    @tempo = config.tempo
    @transitionSmoothness = config.transitionSmoothness
    @sections = []
  
  addSection: (section) ->
    @sections[@sections.length] = section

  play: (afterFinishedCallback) ->
    _this = @
    playNextSection = (sections) ->
      [section, remaining] = headTail(sections)
      section.play(-> 
        if (remaining.length > 0) 
          playNextSection(remaining)
        else
          afterFinishedCallback()
      ) 

    playNextSection @sections




class @Section 

  constructor: (config) ->
    @pane = config.pane
    @tempo = config.tempo
    @notes = []

  addNote: (note) ->
    @notes[@notes.length] = note

  play: (afterFinishedCallback) -> 
    
    thePane = @pane
    thePane.start()
    playNextNote = (notes) ->
      [note, remaining] = headTail(notes)
      note.play(-> 
        if (remaining.length - 1) 
          playNextNote(remaining)
        else
          thePane.stop()
          afterFinishedCallback()
      ) 

    playNextNote @notes

class @Note

  constructor: (config) ->
    @noteFunction = config.noteFunction
    @length = config.length

  play: (afterFinishedCallback) ->
    _this = @
    Meteor.setTimeout(->
      _this.noteFunction()
      afterFinishedCallback()
    , @length)
