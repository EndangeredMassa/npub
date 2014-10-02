license = require './license'
ensureCleanStage = require './clean-stage'
changelog = require './changelog'
openEditor = require './editor'
updateVersion = require './version'
commitChanges = require './commit-changes'
test = require './test'
git = require './git'
fs = require 'fs'

endIf = (exitCodeOrError, message) ->
  return unless exitCodeOrError?

  if exitCodeOrError instanceof Error
    console.error "[npub] " + exitCodeOrError.message
    process.exit(1)
  else
    return if exitCodeOrError == 0
    message ?= "exited with #{exitCodeOrError}"
    console.error "[npub] " + message
    process.exit(exitCodeOrError)

module.exports = (dir, version, config) ->
  ensureCleanStage dir, (error) ->
    endIf(error)

    license(dir, config)
    ensureCleanStage dir, (error) ->
      endIf(error)

      test dir, (error) ->
        endIf(error)

        changelog.build dir, (tempChangelog) ->
          tempChangelogPath = changelog.write(tempChangelog)
          openEditor tempChangelogPath, (error) ->
            if error?
              fs.unlinkSync tempChangelogPath
              endIf(error)

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

