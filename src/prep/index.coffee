fs = require 'fs'
glob = require 'globber'

SOURCE_FILES = [
  '.coffee'
  '.js'
]

readFile = (filePath) ->
  buffer = fs.readFileSync filePath
  buffer.toString()

module.exports = (dir) ->
  license = readFile "#{dir}/LICENSE"
  if license?
    addLicense(dir, license)

endsWith = (string, ending) ->
  string.indexOf(ending, string.length - ending.length) != -1

endsWithAny = (string, endings) ->
  for ending in endings
    return true if endsWith(string, ending)
  false

getSourceFiles = (dir) ->
  options =
    exclude: 'node_modules'
    recursive: true
    includeDirectories: false

  files = glob.sync dir, options
  files.filter (file) ->
    endsWithAny(file, SOURCE_FILES)

addLicense = (dir, license) ->
  files = getSourceFiles(dir)
  console.log JSON.stringify files

  for file in files
    ensureLicense file, license

ensureLicense = (filePath, license) ->
  file = readFile filePath
  if file.indexOf(license) != 0
    console.log "filePath: adding license"
    prepend filePath, file, license

prepend = (filePath, file, license) ->
  newFile = license + '\n' + file
  tempFilePath = "#{filepath}_tmp"
  fs.writeFileSync tempFilePath, newFile
  fs.renameSync tempFilePath, filePath

