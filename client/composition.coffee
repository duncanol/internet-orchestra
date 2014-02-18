class @Composition
  
  constructor: (config) ->
    @name = config.name
    @tempo = config.tempo
    @transitionSmoothness = config.transitionSmoothness
    @sections = []
  
  addSection: (section) ->
    @sections[@sections.length] = section




class @Section 

  constructor: (config) ->
    @pane = config.pane
    @tempo = config.tempo
    @notePattern = config.notePattern
    @notes = []


  addNote: (note) ->
    @notes[@notes.length] = note




class @Note

  constructor: (config) ->
    @effect = config.effect
    @asyncEffect = config.asyncEffect
    @length = config.length

