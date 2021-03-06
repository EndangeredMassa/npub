// Generated by CoffeeScript 1.9.1
var debug, fs;

fs = require('fs');

debug = require('debug')('version');

module.exports = function(dir, version) {
  var filePath, packageJson;
  filePath = dir + "/package.json";
  packageJson = require(filePath);
  debug("updating " + packageJson.version + " to " + version);
  packageJson.version = version;
  return fs.writeFileSync(filePath, JSON.stringify(packageJson, null, 2) + "\n");
};
