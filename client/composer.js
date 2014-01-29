Composer = function Composer() {

};

Composer.prototype.compose = function(conductor) {

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.slideshow(snippet, {
      wordDelay : 300,
      sourceDelay : 1000,
    });
    conductor.conduct(effect, 0);
  });

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.slideshow(snippet, {
      wordDelay : 100,
      sourceDelay : 500,
    });
    conductor.conduct(effect, 2000);
  });

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.allAtOnce(snippet);
    conductor.conduct(effect, 1000);
  });
};