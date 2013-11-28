bumpVersion = require './version'
shrinkwrap = require './shrinkwrap'
addLicense = require './license'
updateChangelog = require './changelog'

module.exports = (directory, version, config={}) ->
  bumpVersion(directory, version)
  shrinkwrap()
  addLicense(directory, config.license)
  updateChangelog(version)

