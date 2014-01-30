Composer = function Composer() {

};

Composer.prototype.compose = function(conductor) {

  var _this = this;

  this.conductor = conductor;
  var rollingPane = this.rollingPane();

  Meteor.setTimeout(function() {
    var gridPane = _this.gridPane();
    rollingPane.stop();
  }, 10000);
};

Composer.prototype.rollingPane = function() {

  var _this = this;

  var rollingPane = new Panes.RollingPane({
    domParent : 'div.main-container'
  });
  rollingPane.start();

  var rollingPaneAdd = function(timeout) {
    Meteor.setTimeout(function() {
      Meteor.call('getSnippet', function(errors, snippet) {
        var effect = Effects.snippetEffects.slideshow(snippet, {
          wordDelay : Math.round(Math.random() * 300),
          sourceDelay : Math.round(Math.random() * 1000),
        });
        _this.conductor.conduct(rollingPane, effect, 0);
        rollingPaneAdd(Math.round(Math.random() * 5000));
      });
    }, timeout);
  };

  rollingPaneAdd(0);

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.allAtOnce(snippet);
    self.conductor.conduct(rollingPane, effect, 1000);
  });

  return rollingPane;
};

Composer.prototype.gridPane = function() {

  var _this = this;

  var gridPane = new Panes.GridPane({
    domParent : 'div.main-container'
  });
  gridPane.start();

  var gridPaneAdd = function(timeout) {
    Meteor.setTimeout(function() {
      Meteor.call('getSnippet', function(errors, snippet) {
        var effect = Effects.snippetEffects.slideshow(snippet, {
          wordDelay : 300,
          sourceDelay : 1000,
        });
        _this.conductor.conduct(gridPane, effect, 0);
        gridPaneAdd(Math.round(Math.random() * 10000));
      });
    }, timeout);
  };

  gridPaneAdd(0);

  return gridPane;
};