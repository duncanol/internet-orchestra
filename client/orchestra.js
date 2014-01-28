Orchestra = function Orchestra(composer, conductor) {
  this.composer = composer;
  this.conductor = conductor;
};

Orchestra.prototype.start = function() {
  this.composer.compose(this.conductor);
};