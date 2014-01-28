Composer = function Composer() {

};

Composer.prototype.compose = function(conductor) {

  var addNewSlideshowDomFn = function() {
    var $messagesBlock = jQuery('#snippet-show');
    return jQuery('<li class="well"></li>').appendTo($messagesBlock);
  };

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.slideshow(snippet, {
      addTextContainerToDomFn : addNewSlideshowDomFn,
      wordDelay : 300,
      sourceDelay : 1000,
    });
    conductor.conduct(effect, 0);
  });

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.slideshow(snippet, {
      addTextContainerToDomFn : addNewSlideshowDomFn,
      wordDelay : 100,
      sourceDelay : 500,
    });
    conductor.conduct(effect, 2000);
  });

  Meteor.call('getSnippet', function(errors, snippet) {
    var effect = Effects.snippetEffects.allAtOnce(snippet, {
      addTextContainerToDomFn : addNewSlideshowDomFn
    });
    conductor.conduct(effect, 1000);
  });
};