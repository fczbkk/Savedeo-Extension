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
  '*://*.vine.co/*'
  '*://*.twitch.tv/*'
  '*://*.metacafe.com/watch/*'
  '*://*.mixcloud.com/*'
)

# TODO move this to shared code, parametrize `utm_medium`
constructUrl = (url = '') ->
  base_url = 'http://savedeo.com/download'
  params_list =
    utm_source: 'browser_extension'
    utm_medium: 'firefox'
    url: encodeURI url
  params = ("#{key}=#{val}" for key, val of params_list).join '&'
  "#{base_url}?#{params}"


handleTabState = ->
  if urlPatterns.test tab.activeTab.url
    downloadButton = widget.Widget
      id: 'savedeo-download-icon'
      label: 'Save video(s) using Savedeo'
      contentURL: data.url 'icon16.png'
      onClick: ->
        tab.open
          url: constructUrl tab.activeTab.url
  else
    downloadButton.destroy() if downloadButton?

tab.on 'activate', -> handleTabState()
tab.on 'ready', -> handleTabState()
