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
    touch.sync changelogPath
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

  write: (changelog, filePath) ->
    mkdirp.sync '/tmp/npub'
    fs.writeFileSync filePath, changelog, {flag: 'w'}
    debug "wrote #{filePath}"

  update: (filePath) ->
    debug "update from #{filePath}"
    touch.sync changelogPath
    newChangelog = fs.readFileSync filePath
    @write newChangelog, changelogPath
