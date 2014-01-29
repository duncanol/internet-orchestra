Conductor = function Conductor() {

};

Conductor.prototype.conduct = function(pane, effect, delay) {
  Meteor.setTimeout(function() {
    pane.addEffect(effect);
  }, delay);
};