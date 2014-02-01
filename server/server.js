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
      console.log("Returning snippet " + snippet);
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
        var text = domNode.text();
        var type = pattern;

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
      });
    }
  }
};

Meteor.startup(function() {

  var scraper = new Scraper();

  Meteor.setInterval(function() {
    if (lookupSourceCollection.find({}).count() > 0) {

      var url = getRandomEntry(lookupSourceCollection, {
        type : 'url'
      });
      scraper.scrapeUrl(url.source, [ 'h1', 'h2', 'h3', 'h4', 'p', 'a' ]);
    }
  }, 2000);
});
