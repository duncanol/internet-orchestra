Meteor.startup(function() {
  var orchestra = new Orchestra(new Composer(), new Conductor());
  orchestra.start();
});