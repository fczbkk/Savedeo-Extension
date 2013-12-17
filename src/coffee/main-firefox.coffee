widget = require('sdk/widget')
data = require('sdk/self').data
tab = require('sdk/tabs')
UrlMatch = require('./url-match').UrlMatch

downloadButton = null

urlPatterns = new UrlMatch(
  '*://*.youtube.com/watch*'
  '*://*.youtube.com/playlist*'
  '*://*.youtube.com/user*'
  '*://*.youtube.com/channel/*'
  '*://*.vimeo.com/*'
  '*://*.facebook.com/photo.php'
  '*://*.ted.com/talks/*'
  '*://*.instagram.com/p/*'
  '*://*.flickr.com/photos/*'
  '*://*.vevo.com/watch/*'
  '*://*.dailymotion.com/video/*'
  '*://*.blip.tv/*'
  '*://*.collegehumor.com/video/*'
  '*://trailers.apple.com/trailers/*'
  '*://tv.adobe.com/embed/*'
  '*://helpx.adobe.com/creative-cloud/tutorials/videos/*'
  '*://*.soundcloud.com/*'
)

handleTabState = ->
  if urlPatterns.test tab.activeTab.url
    downloadButton = widget.Widget
      id: 'savedeo-download-icon'
      label: 'Save video(s) using Savedeo'
      contentURL: data.url 'icon16.png'
      onClick: ->
        tab.open
          url: "http://savedeo.com/download?url=#{encodeURI tab.activeTab.url}"
  else
    downloadButton.destroy() if downloadButton?

tab.on 'activate', -> handleTabState()
tab.on 'ready', -> handleTabState()
