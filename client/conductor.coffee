class @Conductor

  constructor: -> 


  conduct: (composition, finishedCompositionCallback) -> 
  	@conductComposition(composition, finishedCompositionCallback)


  conductComposition: (composition, finishedCompositionCallback) -> 

    _this = @
    conductNextSection = (sections, sectionIndex) ->
      [section, remaining] = headTail(sections)
      _this.conductSection(section, sectionIndex, -> 
        if (remaining.length > 0) 
          conductNextSection(remaining, sectionIndex + 1)
        else
          console.debug("<<<<<<<< Finished conducting Composition #{composition.name} with #{composition.sections.length} sections")
          Session.set("composition", null)
          Session.set("sectionNumber", null)
          Session.set("noteNumber", null)
          finishedCompositionCallback()
      ) 

    console.debug(">>>>>>>> Starting to conduct Composition #{composition.name} with #{composition.sections.length} sections")
    Session.set("composition", 
      name: composition.name, 
      bpm: Math.floor(60 / (composition.tempo / 1000)) * 4
    )
    conductNextSection composition.sections, 0
  

  conductSection: (section, sectionIndex, finishedSectionCallback) ->

    _this = @
    pane = section.pane
    pane.start()
    conductNextNote = (notes, noteIndex) ->
      [note, remaining] = headTail(notes)
      _this.conductNote(note, noteIndex, pane, -> 
        if (remaining.length > 0) 
          conductNextNote(remaining, noteIndex + 1)
        else
          pane.stop()
          console.debug("<<<< Finished conducting Section with #{section.notes.length} notes with note pattern #{section.notePattern}")
          finishedSectionCallback()
      ) 

    console.debug(">>>> Starting to conduct Section with #{section.notes.length} notes with note pattern #{section.notePattern}")
    Session.set("sectionNumber", sectionIndex + 1)
    conductNextNote section.notes, 0


  conductNote: (note, noteIndex, pane, finishedNoteCallback) ->

    console.debug(">> Starting to conduct note with #{note.length} length")
    Session.set("noteNumber", noteIndex + 1)
      
    note.getEffect((effect) ->
      pane.addEffect effect
    )

    Meteor.setTimeout(->
      console.debug("<< Finished conducting note with #{note.length} length")
      finishedNoteCallback()
    , note.length)


Template.nowPlayingTemplate.composition = -> Session.get("composition")

Template.nowPlayingTemplate.sectionNumber = -> Session.get("sectionNumber")

Template.nowPlayingTemplate.noteNumber = -> Session.get("noteNumber")