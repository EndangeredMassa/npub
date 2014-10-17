fs = require 'fs'
mkdirp = require 'mkdirp'
touch = require 'touch'
debug = require('debug') 'changelog'

module.exports = (dir, git) ->
  build: (callback) ->
    # TODO: switch to PR messages and links
    debug "build"
    git.diffSinceLastTag callback

  write: (changelog, filePath='/tmp/npub/changelog.md') ->
    # TODO: use library to create temp file
    mkdirp.sync '/tmp/npub'
    fs.writeFileSync filePath, changelog, {flag: 'w'}
    debug "wrote #{filePath}"
    filePath

  update: (filePath) ->
    changelogPath = "#{dir}/CHANGELOG.md"
    touch.sync changelogPath
    newChangelog = fs.readFileSync filePath
    currentChangelog = fs.readFileSync changelogPath
    newChangelog += currentChangelog
    debug "prepend addition"
    @write newChangelog, changelogPath

