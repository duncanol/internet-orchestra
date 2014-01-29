Conductor = function Conductor() {

};

var addNewSlideshowDomFn = function() {
  var $messagesBlock = jQuery('#snippet-show');
  return jQuery('<li class="well"></li>').appendTo($messagesBlock);
};

Conductor.prototype.conduct = function(effect, delay) {
  Meteor.setTimeout(function() {
    effect.start(addNewSlideshowDomFn);
  }, delay);
};