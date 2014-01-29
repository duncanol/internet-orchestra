Meteor.startup(function() {

  jQuery('#snippet-share').on('click', function() {

    var text = jQuery('#snippet-text');
    var source = jQuery('#snippet-source');

    if (text.val().length > 0 && source.val().length > 0) {
      snippetsCollection.insert({
        text : text.val(),
        source : source.val()
      });

      text.val('');
      source.val('');

      jQuery('#input-snippets-feedback').append('Thanks!');
    }

    return false;
  });
});

Meteor.startup(function() {
  var orchestra = new Orchestra(new Composer(), new Conductor());
  orchestra.start();
});