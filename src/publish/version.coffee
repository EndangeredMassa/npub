fs = require 'fs'
debug = require('debug') 'version'

module.exports = (dir, version) ->
  filePath = "#{dir}/package.json"
  packageJson = require filePath
  debug "updating #{packageJson.version} to #{version}"
  packageJson.version = version
  fs.writeFileSync filePath, JSON.stringify(packageJson, null, 2)

