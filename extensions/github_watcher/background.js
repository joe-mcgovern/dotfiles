var map = {};
chrome.browserAction.setBadgeText({text: "0"});

var updateBadge = function() {
  var sum = 0;
  for (var key in map) {
    if (map.hasOwnProperty(key)) {
      sum += map[key];
    }
  }
  chrome.browserAction.setBadgeText({text: sum.toString()});
};

chrome.runtime.onConnect.addListener(function(port) {
  port.onMessage.addListener(function(msg) {
    map[port.name] = msg.value;
    updateBadge();
  });
  port.onDisconnect.addListener(function() {
    var portName = port.name;
    delete map[port.name];
    setTimeout(function() {
      if (portName in map) {
        return;
      }
      else {
        updateBadge();
      }
    }, 2000);
  });
});
