getRandomEntry = (collection, query) ->
  
  # TODO - horribly inefficient!
  entries = collection.find(query).fetch()
  count = entries.length
  i = Math.floor(Math.random() * (count - 1))
  entries[i]

Meteor.methods 
  getSnippet: (snippetTypes, snippetTags) ->

    filter = {}
    if snippetTypes? then filter.type = $in: snippetTypes

    if snippetTags? then filter.tags = $in: snippetTags

    console.log "Looking for snippet based on filter " + JSON.stringify(filter, undefined, 2);
      
    if snippetsCollection.find(filter).count() > 0
      snippet = getRandomEntry(snippetsCollection, filter)
      console.log "Returning snippet " + snippet.text
      snippet
    else 
      text: "404"
      source: "no source"
  



class Scraper

  scrapeUrl: (source, patterns) ->
    _this = @
    url = source.source
    console.log "Scraping URL " + url + " for patterns " + patterns + "..."
    
    for pattern in patterns
      result = Meteor.http.get(url)
      html = cheerio.load(result.content)
      matches = html(pattern)
      if matches? and matches.length > 0
        matches.each( (i, elem) ->
          domNode = cheerio(elem)
          pureText = domNode.text().trim()

          if pureText.length > 0

            escaped = _this.escapeTextBeforeStoring(pureText)

            type = pattern
          
            existing = snippetsCollection.find(
              text: escaped
              source: url
              type: type
            ).count()

            if existing is 0
              console.log "Inserting " + escaped
              
              record =
                text: escaped
                source: url
                type: type

              if domNode.is("a") then record.href = domNode.attr("href")
              if source.tags? then record.tags = source.tags

              snippetsCollection.insert record
        )

  escapeTextBeforeStoring: (pureText) ->
    @trim(@singleLine(@replaceMicrosoftCharacters(pureText)))


  replaceMicrosoftCharacters: (pureText) ->
    # smart single quotes and apostrophe
    escaped = pureText.replace(/[\u2018|\u2019|\u201A]/g, "\'")
    # smart double quotes
    escaped = escaped.replace(/[\u201C|\u201D|\u201E]/g, "\"")
    # ellipsis
    escaped = escaped.replace(/\u2026/g, "...")
    # dashes
    escaped = escaped.replace(/[\u2013|\u2014]/g, "-")
    # circumflex
    escaped = escaped.replace(/\u02C6/g, "^")
    # open angle bracket
    escaped = escaped.replace(/\u2039/g, "")
    # spaces
    escaped.replace(/[\u02DC|\u00A0]/g, " ")


  singleLine: (pureText) ->
    pureText.split('\n')[0]
    

  trim: (pureText) ->
    pureText.replace('\\t', " ").trim()


Meteor.startup ->
  
  resetAllSourcesLastCheckedDates()
  scraper = new Scraper()
  
  Meteor.setInterval (->
    if lookupSourceCollection.find({}).count() > 0
      yesterday = new Date()
      yesterday.setMilliseconds yesterday.getMilliseconds() - (24 * 60 * 60 * 1000)
      url = getRandomEntry(lookupSourceCollection,
        type: "url"
        lastChecked:
          $lt: yesterday
      )
      if url?
        url.lastChecked = new Date()
        lookupSourceCollection.update
          _id: url._id
        , url
        scraper.scrapeUrl url, ["h1", "h2", "h3", "h4", "p", "a"]
  ), 10000


resetAllSourcesLastCheckedDates = ->
  sources = lookupSourceCollection.find({}).fetch()
  
  for source in sources
    date = new Date()
    date.setYear 0
    source.lastChecked = date
    lookupSourceCollection.update
      _id: source._id
    , source