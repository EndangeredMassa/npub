fs = require 'fs'

module.exports = (dir, version) ->
  filePath = "#{dir}/package.json"
  packageJson = require filePath
  packageJson.version = version
  fs.writeFileSync filePath, JSON.stringify(packageJson, null, 2)

