@snippetsCollection = new Meteor.Collection 'snippets'

@lookupSourceCollection = new Meteor.Collection 'lookupSources'

Meteor.startup( ->
  console.log 'Ready!'
)