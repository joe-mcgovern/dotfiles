var getNumberOfUnreadIssues = function() {
  var number = 0;
  var unreadIssues = $('.js-issue-row.unread');
  unreadIssues.each(function() {
    var issue = $(this);
    var author = issue.find('.opened-by').find('.muted-link').text().trim();
    if (author == 'josephmcgovern-wf') {
      number ++;
    }
  });
  return number;
};

var port = chrome.runtime.connect({name: location.pathname});

var updateNumberOfIssues = function() {
  var number = getNumberOfUnreadIssues();
  if (number > 0) {
    port.postMessage({
      value: number,
    });
  }
};

updateNumberOfIssues();

setInterval(function() {
  updateNumberOfIssues();
  if (document.hidden) {
    location.reload();
  }
}, 5000);
