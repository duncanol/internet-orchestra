var getRandomEntry = function(collection, query) {
  // TODO - horribly inefficient!
  var entries = collection.find(query).fetch();
  var count = entries.length;
  var i = Math.floor(Math.random() * (count - 1));
  return entries[i];
};

Meteor.methods({
  getSnippet : function() {

    if (snippetsCollection.find({}).count() > 0) {
      var snippet = getRandomEntry(snippetsCollection, {});
      console.log("Returning snippet " + snippet.text);
      return snippet;
    }
  }
});

Scraper = function() {
};

Scraper.prototype.scrapeUrl = function(url, patterns) {

  console.log("Scraping URL " + url + " for patterns " + patterns + "...");

  for ( var i = 0; i < patterns.length; i++) {
    var pattern = patterns[i];

    var result = Meteor.http.get(url);
    var html = cheerio.load(result.content);
    var matches = html(pattern);

    if (matches != null && matches.length > 0) {

      matches.each(function(i, elem) {

        var domNode = cheerio(elem);
        var text = domNode.text().trim();
        var type = pattern;

        if (text.length > 0) {

          var existing = snippetsCollection.find({
            text : text,
            source : url,
            type : type
          }).count();

          if (existing == 0) {

            console.log('Inserting ' + text);

            var record = {
              text : text,
              source : url,
              type : type
            };

            if (domNode.is('a')) {
              record.href = domNode.attr('href');
            }

            snippetsCollection.insert(record);
          }
        }
      });
    }
  }
};

Meteor.startup(function() {

  // resetAllSourcesLastCheckedDates();

  var scraper = new Scraper();

  Meteor.setInterval(function() {
    if (lookupSourceCollection.find({}).count() > 0) {

      var yesterday = new Date();
      yesterday.setMilliseconds(yesterday.getMilliseconds() - (24 * 60 * 60 * 1000));

      var url = getRandomEntry(lookupSourceCollection, {
        type : 'url',
        lastChecked : {
          $lt : yesterday
        }
      });

      if (url != null) {
        scraper.scrapeUrl(url.source, [ 'h1', 'h2', 'h3', 'h4', 'p', 'a' ]);
        url.lastChecked = new Date();
        lookupSourceCollection.update({
          _id : url._id
        }, url);
      }
    }
  }, 2000);
});

var resetAllSourcesLastCheckedDates = function() {
  var sources = lookupSourceCollection.find({}).fetch();

  for ( var i = 0; i < sources.length; i++) {
    var date = new Date();
    date.setYear(0);
    sources[i].lastChecked = date;
    lookupSourceCollection.update({
      _id : sources[i]._id
    }, sources[i]);
  }
};