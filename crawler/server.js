var fs, getMatchPattern, handleData, request, saveChromeData, saveFirefoxData, supported_sites_url;

supported_sites_url = 'http://savedeo.com/supportedsites';

request = require('request');

fs = require('fs');

getMatchPattern = function(input) {
  var re;
  if (input == null) {
    input = '';
  }
  re = /\{.*\}/g;
  return "*://*." + (input.replace(re, '*'));
};

saveChromeData = function(match_patterns_list) {
  var path;
  if (match_patterns_list == null) {
    match_patterns_list = [];
  }
  console.log('Writing Chrome data...');
  path = './extension/chrome/manifest.json';
  return fs.readFile(path, function(error, manifest_content) {
    var manifest_json;
    if (error) {
      throw error;
    }
    manifest_json = JSON.parse(manifest_content);
    manifest_json.content_scripts[0].matches = match_patterns_list;
    manifest_content = JSON.stringify(manifest_json, null, '  ');
    return fs.writeFile(path, manifest_content, function() {
      return console.log('Chrome data successfully written...');
    });
  });
};

saveFirefoxData = function(match_patterns_list) {
  var content, path, separator;
  if (match_patterns_list == null) {
    match_patterns_list = [];
  }
  console.log('Writing Firefox data...');
  path = './extension/firefox/lib/match-patterns.js';
  separator = "',\n  '";
  content = "exports.match_patterns = [\n  '" + (match_patterns_list.join(separator)) + "'\n];";
  return fs.writeFile(path, content, function() {
    return console.log('Firefox data successfully written...');
  });
};

handleData = function(data) {
  var item, match_patterns_list;
  if (data == null) {
    data = {};
  }
  match_patterns_list = (function() {
    var _i, _len, _ref, _results;
    _ref = data.supportedsites;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      _results.push(getMatchPattern(item));
    }
    return _results;
  })();
  saveChromeData(match_patterns_list);
  return saveFirefoxData(match_patterns_list);
};

console.log('Requesting data...');

request(supported_sites_url, function(error, response, body) {
  if (!error && response.statusCode === 200) {
    console.log('Data successfuly received...');
    return handleData(JSON.parse(body));
  }
});
