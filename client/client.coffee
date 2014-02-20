@headTail = (array) ->
  if (array.length == 0) 
    [null, Array()]
  else if (array.length == 1) 
    [array[0], Array()]
  else 
    [array[0], array[1..array.length - 1]]


Template.snippetCountTemplate.snippetCount = ->
  snippetsCollection.find({}).count()


Template.snippetTagsCountTemplate.tagsCount = ->

  # TODO horribly inefficient
  allTags = snippetsCollection.find({tags: {$exists: true}}, {fields: {tags: 1}})
  
  tagsCount = {}
  allTags.forEach (document) -> 
    tagsList = document.tags
   
    for tag in tagsList
      tagsCount[tag] = if tagsCount[tag]? then tagsCount[tag] + 1 else 1
  
  numericArray = new Array()
  for tag, count of tagsCount 
    numericArray.push {tag: tag, count: count}

  numericArray.sort( (tag1, tag2) -> 
    tag2.count - tag1.count;
  )

  numericArray


Template.nowPlayingTemplate.composition = -> Session.get("composition")


Template.nowPlayingTemplate.sectionNumber = -> Session.get("sectionNumber")


Template.nowPlayingTemplate.noteNumber = -> Session.get("noteNumber")


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

  jQuery("#scrape-submit").on "click", ->
    source = jQuery("#scraping-source")
    tags = jQuery("#scraping-tags")
    if source.val().length > 0 and tags.val().length > 0
      lastChecked = new Date()
      lastChecked.setYear 0
      lookupSourceCollection.insert
        type: "url"
        source: source.val()
        tags: tags.val().toUpperCase().split(",")
        lastChecked: lastChecked
        
      source.val ""
      tags.val ""
      jQuery("#input-scrape-feedback").append "Thanks!"
    false


Meteor.startup ->
  
  orchestra = new Orchestra(new Composer(), new Conductor())
  orchestra.start()

   