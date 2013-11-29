bumpVersion = require './version'
shrinkwrap = require './shrinkwrap'
addLicense = require './license'
updateChangelog = require './changelog'

module.exports = (directory, version, config={}) ->
  nextVersion = bumpVersion(directory, version)
  shrinkwrap directory, ->
    addLicense(directory, config.license)
    updateChangelog(nextVersion)

