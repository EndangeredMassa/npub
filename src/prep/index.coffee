fs = require 'fs'
addLicense = require './license'

readFile = (filePath) ->
  buffer = fs.readFileSync filePath
  buffer.toString()

module.exports = (dir) ->
  license = readFile "#{dir}/LICENSE"
  if license?
    addLicense(dir, license)

