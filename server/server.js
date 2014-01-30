Meteor.methods({
  getSnippet : function() {

    var count = snippetsCollection.find({}).count();
    var i = Math.round(Math.random() * (count - 1));
    var snippet = snippetsCollection.find({}).fetch()[i];
    console.log("Returning snippet " + snippet);
    return snippet;
  }
});

Meteor.startup(function() {
  // var i = 0;
  // Meteor.setInterval(function() {
  // snippetsCollection.insert({
  // text : 'New text inserted ' + (i += 10),
  // source : 'local'
  // });
  // }, 2000);
});
