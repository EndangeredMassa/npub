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
mkdirp = require 'mkdirp'
touch = require 'touch'
debug = require('debug') 'changelog'

repeat = (pattern, count) ->
  arr = (pattern for idx in [1..count])
  arr.join('')

module.exports = (dir, git) ->
  changelogPath = "#{dir}/CHANGELOG.md"

  build: (version, callback) ->
    # TODO: switch to PR messages and links
    debug "build"
    currentChangelog = fs.readFileSync changelogPath
    git.diffSinceLastTag (err, commits) ->
      return callback(err, commits) if err?

      completeDiff = [
        version,
        repeat("-", version.length),
        commits,
        currentChangelog
      ].join "\n"

      debug "prepend addition"
      callback null, completeDiff

  write: (changelog, filePath='/tmp/npub/changelog.md') ->
    # TODO: use library to create temp file
    mkdirp.sync '/tmp/npub'
    fs.writeFileSync filePath, changelog, {flag: 'w'}
    debug "wrote #{filePath}"
    filePath

  update: (filePath) ->
    debug "update from #{filePath}"
    touch.sync changelogPath
    newChangelog = fs.readFileSync filePath
    @write newChangelog, changelogPath
