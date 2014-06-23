git = require './git'
fs = require 'fs'
mkdirp = require 'mkdirp'

module.exports =
  build: (dir, callback) ->
    # TODO: format the changelog
    git.diffSinceLastTag dir, callback

  write: (changelog, filePath='/tmp/npub/changelog.md') ->
    mkdirp.sync '/tmp/npub'
    fs.writeFileSync filePath, changelog
    filePath

  update: (dir, filePath) ->
    newChangelog = fs.readFileSync filePath
    currentChangelog = fs.readFileSync "#{dir}/CHANGELOG.md"
    newChangelog += currentChangelog
    @write newChangelog, "#{dir}/CHANGELOG.md"

