class @Conductor

  constructor: -> 


  conduct: (composition, afterFinishedCallback) -> 
  	conductComposition(composition, afterFinishedCallback)


  conductComposition: (composition, afterFinishedCallback) ->

  	conductNextSection = (sections) ->
      [section, remaining] = headTail(sections)
      conductSection(section, -> 
        if (remaining.length > 0) 
          conductNextSection(remaining)
        else
          afterFinishedCallback()
      ) 

    conductNextSection composition.sections


  conductSection: (section, afterFinishedCallback) ->

    pane = section.pane
    pane.start()
    conductNextNote = (notes) ->
      [note, remaining] = headTail(notes)
      conductNote(note, pane, -> 
        if (remaining.length - 1) 
          conductNextNote(remaining)
        else
          pane.stop()
          afterFinishedCallback()
      ) 

    conductNextNote @notes


  conductNote: (note, pane, afterFinishedCallback) ->

    addEffectToPane: (effect) ->
      pane.addEffect effect

    Meteor.setTimeout(->
      note.getEffect(addEfectToPane) 
      afterFinishedCallback()
    , @length)


  