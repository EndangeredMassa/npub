fs = require 'fs'
glob = require 'globber'

SOURCE_FILES = {
  'coffee':
    startComment: '###'
    endComment: '###'
  'js':
    startComment: '/*'
    endComment: '*/'
}

module.exports = addLicense = (directory, config={}) ->
  license = readFile "#{directory}/LICENSE"
  return unless license?

  files = getSourceFiles(directory, config.exclude)

  for file in files
    ensureLicense file, license

readFile = (filePath) ->
  buffer = fs.readFileSync filePath
  buffer.toString()

getExtension = (path) ->
  path.split('.').pop()

getSourceFiles = (directory, exclude=[]) ->
  options =
    exclude: ['node_modules'].concat(exclude)
    recursive: true
    includeDirectories: false

  files = glob.sync directory, options
  files = files.map (file) ->
    {
      path: file
      ext: getExtension(file)
    }

  files.filter (file) ->
    file.ext in (Object.keys SOURCE_FILES)

ensureLicense = (file, license) ->
  file.content = readFile file.path

  newline = '\n'
  {startComment, endComment} = SOURCE_FILES[file.ext]
  license = startComment + newline + license + endComment + newline + newline

  if file.content.indexOf(license) != 0
    console.log "#{file.path}: adding license"
    prepend file, license

prepend = (file, license) ->
  newFile = license + file.content

  tempFilePath = "#{file.path}_tmp"
  fs.writeFileSync tempFilePath, newFile
  fs.renameSync tempFilePath, file.path

