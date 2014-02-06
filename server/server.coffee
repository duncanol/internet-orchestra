getRandomEntry = (collection, query) ->
  
  # TODO - horribly inefficient!
  entries = collection.find(query).fetch()
  count = entries.length
  i = Math.floor(Math.random() * (count - 1))
  entries[i]

Meteor.methods getSnippet: ->
  if snippetsCollection.find({}).count() > 0
    snippet = getRandomEntry(snippetsCollection, {})
    console.log "Returning snippet " + snippet.text
    snippet

class Scraper

  scrapeUrl: (url, patterns) ->
    console.log "Scraping URL " + url + " for patterns " + patterns + "..."
    
    for pattern in patterns
      result = Meteor.http.get(url)
      html = cheerio.load(result.content)
      matches = html(pattern)
      if matches? and matches.length > 0
        matches.each( (i, elem) ->
          domNode = cheerio(elem)
          text = domNode.text().trim()
          type = pattern
          if text.length > 0
            existing = snippetsCollection.find(
              text: text
              source: url
              type: type
            ).count()
            if existing is 0
              console.log "Inserting " + text
              record =
                text: text
                source: url
                type: type

              record.href = domNode.attr("href")  if domNode.is("a")
              snippetsCollection.insert record
        )


Meteor.startup ->
  
  # resetAllSourcesLastCheckedDates();
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
        scraper.scrapeUrl url.source, ["h1", "h2", "h3", "h4", "p", "a"]
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