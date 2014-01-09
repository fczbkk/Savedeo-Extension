var UrlMatch, data, downloadButton, handleTabState, tab, urlPatterns, widget;

widget = require('sdk/widget');

data = require('sdk/self').data;

tab = require('sdk/tabs');

UrlMatch = require('./url-match').UrlMatch;

downloadButton = null;

urlPatterns = new UrlMatch('*://*.youtube.com/watch*', '*://*.youtube.com/playlist*', '*://*.youtube.com/user*', '*://*.youtube.com/channel/*', '*://*.vimeo.com/*', '*://*.facebook.com/photo.php', '*://*.ted.com/talks/*', '*://*.instagram.com/p/*', '*://*.flickr.com/photos/*', '*://*.vevo.com/watch/*', '*://*.dailymotion.com/video/*', '*://*.blip.tv/*', '*://*.collegehumor.com/video/*', '*://trailers.apple.com/trailers/*', '*://tv.adobe.com/embed/*', '*://helpx.adobe.com/creative-cloud/tutorials/videos/*', '*://*.soundcloud.com/*', '*://*.vine.co/*', '*://*.twitch.tv/*', '*://*.metacafe.com/watch/*', '*://*.mixcloud.com/*');

handleTabState = function() {
  if (urlPatterns.test(tab.activeTab.url)) {
    return downloadButton = widget.Widget({
      id: 'savedeo-download-icon',
      label: 'Save video(s) using Savedeo',
      contentURL: data.url('icon16.png'),
      onClick: function() {
        return tab.open({
          url: "http://savedeo.com/download\n?utm_source=browser_extension\n&utm_medium=firefox\n&url=" + (encodeURI(tab.activeTab.url))
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
