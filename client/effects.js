Effects = {};

Effects.snippetEffects = {};

Effects.snippetEffects.slideshow = function(snippet, overrideConfig) {

  return {
    start : function() {

      var config = {
        wordDelay : 300,
        sourceDelay : 1000
      };

      jQuery.extend(config, overrideConfig);

      var $domNode = config.addTextContainerToDomFn();

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

Effects.snippetEffects.allAtOnce = function(snippet, overrideConfig) {

  return {
    start : function() {

      var config = {};

      jQuery.extend(config, overrideConfig);

      var $domNode = config.addTextContainerToDomFn();

      var words = snippet.text;
      var source = snippet.source;
      $domNode.append(words);
      $domNode.append(' <a href="' + source + '">' + source + '</a>');
    }
  };
};