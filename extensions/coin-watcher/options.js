$(document).ready(function() {
  chrome.storage.sync.get(['alerts'], function(result) {
    var alerts = result.alerts || [];
    if (alerts.length == 0) {
      $('.alerts').html('<i>No existing alerts</i>');
      return;
    }
    else {
      $('.alerts').html('Alerts exist, but I dont know how to show them');
    }
  });

  $('.add-alert').click(function() {
    console.log("Adding alert");
    $('.alert-modal').modal();
  });
});
