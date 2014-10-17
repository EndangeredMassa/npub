// Generated by CoffeeScript 2.0.0-beta7
void function () {
  var debug, fs;
  fs = require('fs');
  debug = require('debug')('version');
  module.exports = function (dir, version) {
    var filePath, packageJson;
    filePath = '' + dir + '/package.json';
    packageJson = require(filePath);
    debug('updating ' + packageJson.version + ' to ' + version);
    packageJson.version = version;
    return fs.writeFileSync(filePath, JSON.stringify(packageJson, null, 2));
  };
}.call(this);