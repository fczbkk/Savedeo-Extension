constructUrl = (url = '', utm_medium = browser_type or '') ->
  base_url = 'http://savedeo.com/download'
  params_list =
    utm_source: 'browser_extension'
    utm_medium: utm_medium
    url: encodeURI url
  params = ("#{key}=#{val}" for key, val of params_list).join '&'
  "#{base_url}?#{params}"