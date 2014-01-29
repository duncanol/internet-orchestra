Effects = {};

Effects.snippetEffects = {};

Effects.snippetEffects.slideshow = function(snippet, overrideConfig) {

  return {
    start : function($domNode) {

      var config = {
        wordDelay : 300,
        sourceDelay : 1000
      };

      jQuery.extend(config, overrideConfig);

      var words = snippet.text.split(" ", 100);
      var source = snippet.source;
      var i = 0;
      var interval = 0;
      interval = Meteor.setInterval(function() {
        var nextWord = words[i++];

        if (i == 0) {
          $domNode.append('<p>');
        }

        $domNode.append(nextWord + (i > 0 ? " " : ""));

        if (i == words.length) {
          $domNode.append('</p>');
        }

        if (i == words.length) {
          Meteor.clearInterval(interval);
          Meteor.setTimeout(function() {
            $domNode.append('<p><a href="' + source + '">' + source + '</a></p>');
          }, config.sourceDelay);
        }
      }, config.wordDelay);
    }
  };
};

Effects.snippetEffects.allAtOnce = function(snippet, overrideConfig) {

  return {
    start : function($domNode) {

      var config = {};

      jQuery.extend(config, overrideConfig);

      var words = snippet.text;
      var source = snippet.source;
      $domNode.append('<p>' + words + '</p>');
      $domNode.append('<p><a href="' + source + '">' + source + '</a></p>');
    }
  };
};