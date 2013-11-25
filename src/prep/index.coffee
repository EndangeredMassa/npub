fs = require 'fs'
addLicense = require './license'

readFile = (filePath) ->
  buffer = fs.readFileSync filePath
  buffer.toString()

module.exports = (dir, workingDir, config) ->
  license = readFile "#{workingDir}/LICENSE"
  if license?
    addLicense(dir, license, config?.license)

