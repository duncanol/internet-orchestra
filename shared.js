snippetsCollection = new Meteor.Collection('snippets');

lookupSourceCollection = new Meteor.Collection('lookupSources');

Meteor.startup(function() {
  console.log('Ready!');
});