@headTail = (array) ->
  if (array.length == 0) 
    [null, Array()]
  else if (array.length == 1) 
    [array[0], Array()]
  else 
    [array[0], array[1..array.length - 1]]

Meteor.startup ->
  jQuery("#snippet-share").on "click", ->
    text = jQuery("#snippet-text")
    source = jQuery("#snippet-source")
    if text.val().length > 0 and source.val().length > 0
      snippetsCollection.insert
        text: text.val()
        source: source.val()

      text.val ""
      source.val ""
      jQuery("#input-snippets-feedback").append "Thanks!"
    false


Meteor.startup ->
  
  Meteor.call "getTagCounts", (errors, tagCounts) ->
    if not errors?  
      for tagCount in tagCounts
        jQuery('.all-tags').append tagCount.tag + " (" + tagCount.count + ") / "
    else
      console.error errors
      
  orchestra = new Orchestra(new Composer(), new Conductor())
  orchestra.start()

   