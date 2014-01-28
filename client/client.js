var createSlideshow = function(snippet) {

  return {
    start : function(overrideConfig) {

      var config = {
        wordDelay : 300,
        sourceDelay : 1000
      };

      jQuery.extend(config, overrideConfig);

      var $domNode = config.addSlideshowContainerToDomFn();

      var words = snippet.text.split(" ", 100);
      var source = snippet.source;
      var i = 0;
      var interval = 0;
      interval = Meteor.setInterval(function() {
        var nextWord = words[i++];

        $domNode.append(nextWord + (i > 0 ? " " : ""));

        if (i == words.length) {
          Meteor.clearInterval(interval);
          Meteor.setTimeout(function() {
            $domNode.append('<a href="' + source + '">' + source + '</a>');
          }, config.sourceDelay);
        }
      }, config.wordDelay);
    }
  };
};

Meteor.startup(function() {

  var addNewSlideshowDomFn = function() {
    var $messagesBlock = jQuery('#snippet-show');
    return jQuery('<li class="well"></li>').appendTo($messagesBlock);
  };

  Meteor.call('getSnippet', function(error, snippet) {

    var slideshow = createSlideshow({
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

      var slideshow = createSlideshow({
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
});