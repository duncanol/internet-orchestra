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
      var $header = jQuery('<h2>' + snippet.type + '</h2>');

      var $paragraph;
      if (snippet.href != null) {
        $paragraph = jQuery('<a href="' + snippet.href + '"><span></span></a>');
      } else {
        $paragraph = jQuery('<p><span></span></p>');
      }
      $domNode.append($header);
      $domNode.append($paragraph);

      interval = Meteor.setInterval(function() {
        var nextWord = words[i++];

        $paragraph.find('span').append(nextWord + (i > 0 ? " " : ""));

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

Effects.snippetEffects.ticker = function(snippet, overrideConfig) {

  return {
    start : function($domNode) {

      var config = {
        charDelay : 300,
        sourceDelay : 1000
      };

      jQuery.extend(config, overrideConfig);

      var source = snippet.source;
      var i = 0;
      var interval = 0;
      var $header = jQuery('<h2>' + snippet.type + '</h2>');

      var $paragraph;
      if (snippet.href != null) {
        $paragraph = jQuery('<a href="' + snippet.href + '"><span></span></a>');
      } else {
        $paragraph = jQuery('<p><span></span></p>');
      }
      $domNode.append($header);
      $domNode.append($paragraph);

      interval = Meteor.setInterval(function() {
        var nextChar = source[i++];

        $paragraph.find('span').append(nextChar);

        if (i == source.length) {
          Meteor.clearInterval(interval);
          Meteor.setTimeout(function() {
            $domNode.append('<p><a href="' + source + '">' + source + '</a></p>');
          }, config.sourceDelay);
        }
      }, config.wordDelay);
    }
  };
};
