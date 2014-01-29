Meteor.methods({
  getSnippet : function() {

    var count = snippetsCollection.find({}).count();
    var i = Math.round(Math.random() * (count - 1));
    var snippet = snippetsCollection.find({}).fetch()[i];
    console.log("Returning snippet " + snippet);
    return snippet;
  }
});
