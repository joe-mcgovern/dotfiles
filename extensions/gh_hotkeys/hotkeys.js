var keys = [];

function performHotKey() {
  if (String.fromCharCode(keys[0].which).toLowerCase() == 'o') { // open issue
    delete keys[0];
    keys = keys.map(function(key) {
      return String.fromCharCode(key.which);
    });
    var strNumber = keys.join('');
    try {
      var number = parseInt(strNumber);
    }
    catch(err) {
      return;
    }
    var url = location.href.split('/pulls')[0];
    url = location.href.split('/pull')[0];
    location.href = url + "/pull/" + number.toString();
  }
  else if (keys[0].which == 219) {
    if (String.fromCharCode(keys[1].which).toLowerCase() == 'f') {
      var url = location.href;
      var splitUrl = url.split('/pull/');
      var base = splitUrl[0];
      var number = splitUrl[1].split('/')[0];
      location.href = base + '/pull/' + number + '/files';
    }
    if (String.fromCharCode(keys[1].which).toLowerCase() == 'm') {
      var url = location.href;
      var splitUrl = url.split('/pull/');
      var base = splitUrl[0];
      var number = splitUrl[1].split('/')[0];
      location.href = base + '/pull/' + number;
    }
    if (String.fromCharCode(keys[1].which).toLowerCase() == 'x') {
      var url = location.href;
      var splitUrl = url.split('/pull/');
      var base = splitUrl[0];
      var number = splitUrl[1].split('/')[0];
      location.href = base + '/pull/' + number + '/commits';
    }

  }
}

function processKeys() {
  if (keys.length == 0) {
    return;
  }
  var lastKey = keys[keys.length - 1];
  if (lastKey.which == 13) {
    performHotKey();
    keys = [];
  }
  else if (lastKey.shiftKey) {
    keys = [];
  }
}

$(window).keydown(function(e) {
  console.log("Adding key: ", e.which,  String.fromCharCode(e.which));
  keys.push(e);
  processKeys();
});
