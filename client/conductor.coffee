class @Conductor

  constructor: -> 


  conduct: (composition, afterFinishedCallback) -> 
  	@conductComposition(composition, afterFinishedCallback)


  conductComposition: (composition, afterFinishedCallback) -> 

    _this = @
    conductNextSection = (sections) ->
      [section, remaining] = headTail(sections)
      _this.conductSection(section, -> 
        if (remaining.length > 0) 
          conductNextSection(remaining)
        else
          afterFinishedCallback()
          console.debug("Finished conducting Composition #{composition.name}")
      ) 

    console.debug("Starting to conduct Composition #{composition.name}")
    conductNextSection composition.sections
  

  conductSection: (section, afterFinishedCallback) ->

    _this = @
    pane = section.pane
    pane.start()
    conductNextNote = (notes) ->
      [note, remaining] = headTail(notes)
      _this.conductNote(note, pane, -> 
        if (remaining.length - 1) 
          conductNextNote(remaining)
        else
          pane.stop()
          afterFinishedCallback()
          console.debug("Finished conducting Section with #{section.notes.length} notes")
      ) 

    console.debug("Starting to conduct Section with #{section.notes.length} notes")
    conductNextNote section.notes


  conductNote: (note, pane, afterFinishedCallback) ->

    addEffectToPane = (effect) ->
      pane.addEffect effect

    console.debug("Starting to conduct note with #{note.length} length")

    Meteor.setTimeout(->
      note.getEffect(addEffectToPane) 
      console.debug("Finished conducting note with #{note.length} length")
      afterFinishedCallback()
    , note.length)


  