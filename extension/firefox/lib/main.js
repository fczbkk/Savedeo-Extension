var constructUrl;

constructUrl = function(url, utm_medium) {
  var base_url, key, params, params_list, val;
  if (url == null) {
    url = '';
  }
  if (utm_medium == null) {
    utm_medium = browser_type || '';
  }
  base_url = 'http://savedeo.com/download';
  params_list = {
    utm_source: 'browser_extension',
    utm_medium: utm_medium,
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

var UrlMatch, browser_type, data, downloadButton, handleTabState, match_patterns, pattern, tab, urlPatterns, widget, _i, _len;

match_patterns = require('match-patterns').match_patterns;

widget = require('sdk/widget');

data = require('sdk/self').data;

tab = require('sdk/tabs');

UrlMatch = require('./url-match').UrlMatch;

browser_type = 'firefox';

downloadButton = null;

urlPatterns = new UrlMatch();

for (_i = 0, _len = match_patterns.length; _i < _len; _i++) {
  pattern = match_patterns[_i];
  urlPatterns.addPattern(pattern);
}

handleTabState = function() {
  if (urlPatterns.test(tab.activeTab.url)) {
    return downloadButton = widget.Widget({
      id: 'savedeo-download-icon',
      label: 'Save video(s) using Savedeo',
      contentURL: data.url('icon16.png'),
      onClick: function() {
        return tab.open({
          url: constructUrl(tab.activeTab.url)
        });
      }
    });
  } else {
    if (downloadButton != null) {
      return downloadButton.destroy();
    }
  }
};

tab.on('activate', function() {
  return handleTabState();
});

tab.on('ready', function() {
  return handleTabState();
});
