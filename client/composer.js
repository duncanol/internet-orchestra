Composer = function Composer() {

};

Composer.prototype.compose = function(conductor) {

  var rollingPane = new Panes.RollingPane({
    domParent : 'div.container'
  });
  rollingPane.start();

  var rollingPaneAdd = function(timeout) {
    Meteor.setTimeout(function() {
      Meteor.call('getSnippet', function(errors, snippet) {
        var effect = Effects.snippetEffects.slideshow(snippet, {
          wordDelay : 300,
          sourceDelay : 1000,
        });
        conductor.conduct(rollingPane, effect, 0);
        rollingPaneAdd(Math.round(Math.random() * 10000));
      });
    }, timeout);
  };

  rollingPaneAdd(0);

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.allAtOnce(snippet);
    conductor.conduct(rollingPane, effect, 1000);
  });
};