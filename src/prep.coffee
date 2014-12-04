###
Copyright (c) 2014, Sean Massa
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

Neither the name of GROUPON nor the names of its contributors may be
used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###

fs = require 'fs'
glob = require 'globber'
debug = require('debug') 'license'

SOURCE_FILES = {
  'coffee':
    startComment: '###'
    endComment: '###'
  'js':
    startComment: '/*'
    endComment: '*/'
}

module.exports = (directory, log, config={}) ->
  license = readFile "#{directory}/LICENSE"
  debug "has license: #{license}"
  return unless license?

  files = getSourceFiles(directory, config.license?.exclude)
  debug "files: #{files}"

  for file in files
    ensureLicense file, license, log

readFile = (filePath) ->
  if (fs.existsSync filePath)
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

ensureLicense = (file, license, log) ->
  file.content = readFile file.path

  newline = '\n'
  {startComment, endComment} = SOURCE_FILES[file.ext]
  license = startComment + newline + license + endComment + newline + newline

  if file.content.indexOf(license) != 0
    log "#{file.path}: adding license"
    prepend file, license

prepend = (file, license) ->
  newFile = license + file.content

  tempFilePath = "#{file.path}_tmp"
  fs.writeFileSync tempFilePath, newFile
  fs.renameSync tempFilePath, file.path

