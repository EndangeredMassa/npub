git = require './git'
fs = require 'fs'
mkdirp = require 'mkdirp'
touch = require 'touch'

module.exports =
  build: (dir, callback) ->
    # TODO: format the changelog
    git.diffSinceLastTag dir, callback

  write: (changelog, filePath='/tmp/npub/changelog.md') ->
    # TODO: use library to create temp file
    mkdirp.sync '/tmp/npub'
    fs.writeFileSync filePath, changelog
    filePath

  update: (dir, filePath) ->
    changelogPath = "#{dir}/CHANGELOG.md"
    touch.sync changelogPath
    newChangelog = fs.readFileSync filePath
    currentChangelog = fs.readFileSync changelogPath
    newChangelog += currentChangelog
    @write newChangelog, changelogPath

