supported_sites_url = 'http://savedeo.com/supportedsites'

request = require 'request'
fs = require 'fs'

getMatchPattern = (input = '') ->
  re = /\{.*\}/g
  "*://*.#{input.replace re, '*'}"

saveChromeData = (match_patterns_list = []) ->
  console.log 'Writing Chrome data...'
  path = './extension/chrome/manifest.json'
  fs.readFile path, (error, manifest_content) ->
    if error then throw error
    manifest_json = JSON.parse manifest_content
    manifest_json.content_scripts[0].matches = match_patterns_list
    manifest_content = JSON.stringify manifest_json, null, '  '
    fs.writeFile path, manifest_content, ->
      console.log 'Chrome data successfully written...'

saveFirefoxData = (match_patterns_list = []) ->
  console.log 'Writing Firefox data...'
  path = './extension/firefox/lib/match-patterns.js'
  separator = "',\n  '"
  content = """
    exports.match_patterns = [
      '#{match_patterns_list.join separator}'
    ];
  """
  fs.writeFile path, content, ->
    console.log 'Firefox data successfully written...'

handleData = (data = {}) ->
  match_patterns_list = (getMatchPattern item for item in data.supportedsites)
  saveChromeData match_patterns_list
  saveFirefoxData match_patterns_list

console.log 'Requesting data...'
request supported_sites_url, (error, response, body) ->
  if not error and response.statusCode is 200
    console.log 'Data successfuly received...'
    handleData JSON.parse body