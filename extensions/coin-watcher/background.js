chrome.runtime.onInstalled.addListener(function() {
  console.log("Setting alerts");
  chrome.storage.sync.set({'alerts': []});
});
