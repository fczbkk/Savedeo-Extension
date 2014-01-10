# TODO move this to shared code, parametrize `utm_medium`
constructUrl = (url = '') ->
  base_url = 'http://savedeo.com/download'
  params_list =
    utm_source: 'browser_extension'
    utm_medium: 'chrome'
    url: encodeURI url
  params = ("#{key}=#{val}" for key, val of params_list).join '&'
  "#{base_url}?#{params}"

chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
  if request.what is 'showIcon'
    chrome.pageAction.show sender.tab.id
  true

chrome.pageAction.onClicked.addListener (tab) ->
  chrome.tabs.create
    url: constructUrl tab.url
