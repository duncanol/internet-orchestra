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
  orchestra = new Orchestra(new Composer(), new Conductor())
  orchestra.start()