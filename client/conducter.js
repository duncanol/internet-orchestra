Conducter = {};

Conducter.start = function(overrideConfig) {

  var config = {
    wordDelay : 300,
    sourceDelay : 1000
  };

  jQuery.extend(config, overrideConfig);

  var addNewSlideshowDomFn = function() {
    var $messagesBlock = jQuery('#snippet-show');
    return jQuery('<li class="well"></li>').appendTo($messagesBlock);
  };

  Meteor.call('getSnippet', function(error, snippet) {

    var slideshow = Effects.snippetEffects.slideshow({
      text : snippet.text,
      source : snippet.source
    });

    slideshow.start({
      addSlideshowContainerToDomFn : addNewSlideshowDomFn,
      wordDelay : 300,
      sourceDelay : 1000,
    });
  });

  Meteor.setTimeout(function() {

    Meteor.call('getSnippet', function(error, snippet) {

      var slideshow = Effects.snippetEffects.slideshow({
        text : snippet.text,
        source : snippet.source
      });

      slideshow.start({
        addSlideshowContainerToDomFn : addNewSlideshowDomFn,
        wordDelay : 300,
        sourceDelay : 1000,
      });
    });
  }, 2000);
};