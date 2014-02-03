class @Conductor

  constructor: -> 

  conduct: (pane, effect, delay) -> 
  	Meteor.setTimeout -> 
    	pane.addEffect effect
  	, delay
