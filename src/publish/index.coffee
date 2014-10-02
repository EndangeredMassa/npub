fs = require 'fs'
license = require './license'
ensureCleanStage = require './clean-stage'
changelog = require './changelog'
openEditor = require './editor'
updateVersion = require './version'
commitChanges = require './commit-changes'
npm = require './npm'
git = require './git'
prompt = require './prompt'

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

      npm.test dir, (error) ->
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
              tag = "v#{version}"
              git.tag dir, tag, ->
                prompt version, (error) ->
                  endIf(error)

                  git.push dir, ->
                    git.pushTag dir, tag, ->

                      npm.publish dir, (error) ->
                        endIf(error)

                        console.log 'success!'

                        # TODO: github release notes
                        # TODO: github PR comments

