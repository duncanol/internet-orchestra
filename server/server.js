lookupSourceCollection = new Meteor.Collection('lookupSources');

var getRandomEntry = function(collection, query) {
  // TODO - horribly inefficient!
  var entries = collection.find(query).fetch();
  var count = entries.length;
  var i = Math.round(Math.random() * (count - 1));
  return entries[i];
};

Meteor.methods({
  getSnippet : function() {

    var snippet = getRandomEntry(snippetsCollection, {});
    console.log("Returning snippet " + snippet);
    return snippet;
  }
});

Scraper = function() {
};

Scraper.prototype.scrapeUrl = function(url, patterns) {

  var text = '<h1>This is a header</h1>\
    <p>This is a paragraph.</p>';

  snippetsCollection.insert({
    text : 'This is a paragraph',
    source : url
  });
};

Meteor.startup(function() {

  // var scraper = new Scraper();
  //
  // var i = 0;
  // Meteor.setInterval(function() {
  //
  // var source = getRandomEntry(lookupSources)
  // scraper.scrapeUrl(url, );
  //
  // snippetsCollection.insert({
  // text : 'New text inserted ' + (i += 10),
  // source : 'local'
  // });
  // }, 2000);

  // must be
  // exposed.

  var result = Meteor.http.get("http://www.theonion.com");
  var html = cheerio.load(result.content);
  console.log(html.html());

});
