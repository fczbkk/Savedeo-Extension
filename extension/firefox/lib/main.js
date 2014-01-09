var UrlMatch, constructUrl, data, downloadButton, handleTabState, tab, urlPatterns, widget;

widget = require('sdk/widget');

data = require('sdk/self').data;

tab = require('sdk/tabs');

UrlMatch = require('./url-match').UrlMatch;

downloadButton = null;

urlPatterns = new UrlMatch('*://*.youtube.com/watch*', '*://*.youtube.com/playlist*', '*://*.youtube.com/user*', '*://*.youtube.com/channel/*', '*://*.vimeo.com/*', '*://*.facebook.com/photo.php', '*://*.ted.com/talks/*', '*://*.instagram.com/p/*', '*://*.flickr.com/photos/*', '*://*.vevo.com/watch/*', '*://*.dailymotion.com/video/*', '*://*.blip.tv/*', '*://*.collegehumor.com/video/*', '*://trailers.apple.com/trailers/*', '*://tv.adobe.com/embed/*', '*://helpx.adobe.com/creative-cloud/tutorials/videos/*', '*://*.soundcloud.com/*', '*://*.vine.co/*', '*://*.twitch.tv/*', '*://*.metacafe.com/watch/*', '*://*.mixcloud.com/*');

constructUrl = function(url) {
  var key, params, params_list, val;
  if (url == null) {
    url = '';
  }
  url = 'http://savedeo.com/download';
  params_list = {
    utm_source: 'browser_extension',
    utm_medium: 'firefox',
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
  return "" + url + "?" + params;
};

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
