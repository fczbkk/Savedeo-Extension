var constructUrl;

constructUrl = function(url) {
  var base_url, key, params, params_list, val;
  if (url == null) {
    url = '';
  }
  base_url = 'http://savedeo.com/download';
  params_list = {
    utm_source: 'browser_extension',
    utm_medium: 'chrome',
    url: encodeURI(url)
  };
  params = ((function() {
    var _results;
    _results = [];
    for (key in params_list) {
      val = params_list[key];
      _results.push("" + key + "=" + val);
    }
    return _results;
  })()).join('&');
  return "" + base_url + "?" + params;
};

chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
  if (request.what === 'showIcon') {
    chrome.pageAction.show(sender.tab.id);
  }
  return true;
});

chrome.pageAction.onClicked.addListener(function(tab) {
  return chrome.tabs.create({
    url: constructUrl(tab.url)
  });
});
