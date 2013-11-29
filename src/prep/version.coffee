fs = require 'fs'
semver = require 'semver'
log = require '../log'

getNextVersion = (currentVersion, versionOption) ->
  if versionOption.indexOf('.') > -1
    versionOption
  else
    semver.inc(currentVersion, versionOption)

write = (filePath, object) ->
  output = JSON.stringify object, null, 2
  fs.writeFileSync(filePath, output)

module.exports = (directory, versionOption) ->
  packagePath = "#{directory}/package.json"
  packageJson = require packagePath

  currentVersion = packageJson.version
  nextVersion = getNextVersion(currentVersion, versionOption)

  packageJson.version = nextVersion
  write packagePath, packageJson

  log "updated package to #{nextVersion}"
  return nextVersion

