Conductor = function Conductor() {

};

Conductor.prototype.conduct = function(effect, delay) {
  Meteor.setTimeout(function() {
    effect.start();
  }, delay);
};