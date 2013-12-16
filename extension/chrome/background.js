chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
  if (request.what === 'showIcon') {
    chrome.pageAction.show(sender.tab.id);
  }
  return true;
});

chrome.pageAction.onClicked.addListener(function(tab) {
  return chrome.tabs.create({
    url: "http://savedeo.com/download?url=" + (encodeURI(tab.url))
  });
});
