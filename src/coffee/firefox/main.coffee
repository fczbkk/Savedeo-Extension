match_patterns = require('match-patterns').match_patterns
widget = require('sdk/widget')
data = require('sdk/self').data
tab = require('sdk/tabs')
UrlMatch = require('./url-match').UrlMatch

# used in `constructUrl()`
browser_type = 'firefox'

downloadButton = null

urlPatterns = new UrlMatch()
urlPatterns.addPattern pattern for pattern in match_patterns

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
