bumpVersion = require './version'
shrinkwrap = require './shrinkwrap'
addLicense = require './license'
updateChangelog = require './changelog'

module.exports = (directory, version, config={}) ->
  bumpVersion(version)
  shrinkwrap()
  addLicense(directory, config.license)
  updateChangelog(version)

