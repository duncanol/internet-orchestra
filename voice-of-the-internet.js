if (Meteor.isClient) {
    
    var createSlideshow = function(snippet) {
        
        return {
            start: function(overrideConfig) {
                
                var config = {
                    wordDelay: 300,
                    sourceDelay: 1000
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
    
    var slideshow1 = createSlideshow({
        text: "Hello my name is Duncan and this is a slideshow!",
        source: "www.duncan.com"
    });
    
    var slideshow2 = createSlideshow({
        text: "This is another slideshow that should start soon after!",
        source: "www.another.com"
    });
    
    Meteor.startup(function () {
        
        var addNewSlideshowDomFn = function() {
            var $messagesBlock = jQuery('#message-show');
            return jQuery('<li class="well"></li>').appendTo($messagesBlock);
        };
        
        slideshow1.start({
            addSlideshowContainerToDomFn: addNewSlideshowDomFn,
            wordDelay: 300,
            sourceDelay: 1000,
        });
        
        Meteor.setTimeout(function() {
            slideshow2.start({
                addSlideshowContainerToDomFn: addNewSlideshowDomFn,
                wordDelay: 200,
                sourceDelay: 500,
            });
        });
    });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
