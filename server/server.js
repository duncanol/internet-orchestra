Meteor.methods({
  getSnippet : function() {
    var snippet = {
        text : "Hello my name is Duncan and this is a slideshow!",
        source : "www.duncan.com"
      };
    
    console.log("Returning snippet " + snippet);
    
    return snippet;
  }
});
