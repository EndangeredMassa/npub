license = require './license'
ensureCleanStage = require './clean-stage'
changelog = require './changelog'
openEditor = require './editor'
updateVersion = require './version'
commitChanges = require './commit-changes'
git = require './git'

module.exports = (dir, version, config) ->
  ensureCleanStage dir, ->
    license(dir, config)
    ensureCleanStage dir, ->
      # TODO: verification step: "npm test"
      changelog.build dir, (tempChangelog) ->
        tempChangelogPath = changelog.write(tempChangelog)
        openEditor tempChangelogPath, ->
          # TODO: on non-zero exit code: remove tmp changelog and exit
          changelog.update(dir, tempChangelogPath)
          updateVersion(dir, version)
          commitChanges dir, version, ->
            git.tag dir, "v#{version}", ->
              console.log 'tagged!'

              # TODO: confirm: "publish?"
              # TODO: git push
              # TODO: git push tag
              # TODO: npm publish

              # FUTURE
              # TODO: github release notes
              # TODO: github PR comments

