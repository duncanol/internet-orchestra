Panes = {};

Panes.RollingPane = function(overrideConfig) {

  this.config = {
    numberOfItems : 5,
    domParent : 'body'
  };
  jQuery.extend(this.config, overrideConfig);

  this.$domParent = jQuery(this.config.domParent);
  this.$paneDiv = jQuery('<div class="rolling-pane row"></div>');
  this.$paneList = jQuery('<ul class="rolling-pane-list snippet-block span12"></ul>');
  this.$paneList.appendTo(this.$paneDiv);
};

Panes.RollingPane.prototype.start = function() {
  this.$paneDiv.appendTo(this.$domParent);
};

Panes.RollingPane.prototype.addEffect = function(effect) {
  var $listItems = this.$paneList.find('li');

  if ($listItems.length == this.config.numberOfItems) {
    $listItems[0].remove();
  }

  var $snippetContainer = jQuery('<li class="well"></li>');
  $snippetContainer.appendTo(this.$paneList);
  effect.start($snippetContainer);
};