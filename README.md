Savedeo-Extension
=================

Browser extension that allows you to easily download videos from popular video sites (e.g. YouTube, Vimeo, etc.). Works with Google Chrome and Mozilla Firefox.

You can install the extension from:

* <del>[Google Chrome Store](https://chrome.google.com/webstore/detail/savedeo-video-downloader/dimhjfidnfbaeaamjngcbcnikkcoobog)</del>
  * Google doesn't allow extensions that allow downloading content from YouTube. You'll have to download and use it locally. See below for more details.
* [Mozilla Addons](https://addons.mozilla.org/en-US/firefox/addon/savedeo-video-downloader/)

How to install Google Chrome extension locally
----------------------------------------------

* [Download the source code.](https://github.com/fczbkk/Savedeo-Extension/tree/master/extension/chrome)
* Go to [chrome://extensions/]
* Check the `Developer mode` checkbox in the top right corner.
* Either drag the folder with the extension to the page, or click the `Load unpacked extension...` button and add it manually.

How to develop
--------------

```shell
# check source code for problems and build Coffee to JS
grunt dev

# run dev task every time there's a change in the source
# (this is what you want to run before you start any development)
grunt watch
```

How to do updates
-----------------

```shell
# update list of supported sites
node crawler\server.js

# build new version, bump version number
grunt build
```