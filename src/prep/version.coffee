fs = require 'fs'
semver = require 'semver'

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

  console.log "Updated package to #{nextVersion}"

