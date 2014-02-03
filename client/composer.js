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

  var pane = new Panes.RollingPane({
    domParent : 'div.main-container'
  });
  pane.start();

  var rollingPaneAdd = function(timeout) {
    Meteor.setTimeout(function() {
      Meteor.call('getSnippet', function(errors, snippet) {

        var effect = _this.slideshowEffect(snippet);
        _this.conductor.conduct(pane, effect, 0);

        rollingPaneAdd(Math.round(Math.random() * 5000));
      });
    }, timeout);
  };

  rollingPaneAdd(0);

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = _this.allAtOnceEffect(snippet);
    self.conductor.conduct(pane, effect, 1000);
  });

  return pane;
};

Composer.prototype.slideshowEffect = function(snippet) {
  return Effects.snippetEffects.slideshow(snippet, {
    wordDelay : Math.round(Math.random() * 300),
    sourceDelay : Math.round(Math.random() * 1000),
  });
};

Composer.prototype.allAtOnceEffect = function(snippet) {
  return Effects.snippetEffects.allAtOnce(snippet);
};

Composer.prototype.gridPane = function() {

  var _this = this;

  var pane = new Panes.GridPane({
    domParent : 'div.main-container'
  });
  pane.start();

  var gridPaneAdd = function(timeout) {
    Meteor.setTimeout(function() {
      Meteor.call('getSnippet', function(errors, snippet) {

        var effect = _this.slideshowEffect(snippet);
        _this.conductor.conduct(pane, effect, 0);

        gridPaneAdd(Math.round(Math.random() * 10000));
      });
    }, timeout);
  };

  gridPaneAdd(0);

  return pane;
};