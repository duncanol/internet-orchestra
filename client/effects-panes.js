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

Panes.RollingPane.prototype.stop = function() {
  this.$paneDiv.remove();
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

Panes.GridPane = function(overrideConfig) {

  this.config = {
    width : 4,
    height : 4,
    domParent : 'body'
  };
  jQuery.extend(this.config, overrideConfig);

  this.$domParent = jQuery(this.config.domParent);
  this.$paneDiv = jQuery('<div class="grid-pane"></div>');

  for ( var y = 0; y < this.config.height; y++) {
    var $paneRow = jQuery('<div class="row"></div>');

    for ( var x = 0; x < this.config.width; x++) {
      $paneRow.append('<div class="grid-pane-cell grid-pane-cell-empty snippet-block well span' + Math.round(12 / this.config.width) + '"></div>');
    }
    this.$paneDiv.append($paneRow);
  }
};

Panes.GridPane.prototype.start = function() {
  this.$paneDiv.appendTo(this.$domParent);
};

Panes.RollingPane.prototype.stop = function() {
  this.$paneDiv.remove();
};

Panes.GridPane.prototype.addEffect = function(effect) {
  var $listItems = this.$paneDiv.find('.grid-pane-cell-empty');

  if ($listItems.length == 0) {
    $listItems = this.$paneDiv.find('.grid-pane-cell');
  }

  var $listItem = jQuery($listItems[Math.round(Math.random() * $listItems.length)]);

  var $snippetContainer = jQuery('<span></span>');
  $listItem.html($snippetContainer);
  $listItem.removeClass('grid-pane-cell-empty');

  effect.start($snippetContainer);
};