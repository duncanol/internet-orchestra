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
          console.debug("<<<<<<<< Finished conducting Composition #{composition.name} with #{composition.sections.length} sections")
          afterFinishedCallback()
      ) 

    console.debug(">>>>>>>> Starting to conduct Composition #{composition.name} with #{composition.sections.length} sections")
    conductNextSection composition.sections
  

  conductSection: (section, afterFinishedCallback) ->

    _this = @
    pane = section.pane
    pane.start()
    conductNextNote = (notes) ->
      [note, remaining] = headTail(notes)
      _this.conductNote(note, pane, -> 
        if (remaining.length > 0) 
          conductNextNote(remaining)
        else
          pane.stop()
          console.debug("<<<< Finished conducting Section with #{section.notes.length} notes with note pattern #{section.notePattern}")
          afterFinishedCallback()
      ) 

    console.debug(">>>> Starting to conduct Section with #{section.notes.length} notes with note pattern #{section.notePattern}")
    conductNextNote section.notes


  conductNote: (note, pane, afterFinishedCallback) ->

    console.debug(">> Starting to conduct note with #{note.length} length")

    note.getEffect((effect) ->
      pane.addEffect effect
    )

    Meteor.setTimeout(->
      console.debug("<< Finished conducting note with #{note.length} length")
      afterFinishedCallback()
    , note.length)


  