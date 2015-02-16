fs = require 'fs'
debug = require('debug') 'publish'

prep = require '../prep'
verify = require '../verify'
Changelog = require './changelog'
openEditor = require './editor'
updateVersion = require './version'
commitChanges = require './commit-changes'
Npm = require './npm'
Git = require '../git'
test = require './test'
prompt = require './prompt'
isPrivate = require './public'

EndIf = (log) ->
  endIf = (exitCodeOrError, message) ->
    return unless exitCodeOrError?

    if exitCodeOrError instanceof Error
      log.error exitCodeOrError.message
      process.exit(1)
    else
      return if exitCodeOrError == 0
      message ?= "exited with #{exitCodeOrError}"
      log.error message
      process.exit(exitCodeOrError)

module.exports = (dir, log, config, version, testCommand) ->
  debug "start"

  endIf = EndIf(log)
  git = Git(dir)
  npm = Npm(dir, log)
  changelog = Changelog(dir, git)

  if isPrivate(dir)
    console.log 'Cannot publish this package because it is private.'
    process.exit(2)

  verify dir, (error) ->
    endIf(error)

    prep(dir, log, config)
    debug 'ensured license headers'

    verify dir, (error) ->
      endIf(error)

      test dir, log, npm, testCommand, (error) ->
        endIf(error)

        changelog.build version, (error, tempChangelog) ->
          endIf(error)

          tempChangelogPath = changelog.write(tempChangelog)

          openEditor tempChangelogPath, (error) ->
            if error?
              fs.unlinkSync tempChangelogPath
              endIf(error)

            changelog.update(tempChangelogPath)

            updateVersion(dir, version)

            tag = "v#{version}"
            commitChanges git, tag, (error) ->
              endIf(error)

              git.tag tag, (error) ->
                endIf(error)

                prompt version, (error) ->
                  endIf(error)

                  git.branch (error, branch) ->
                    endIf(error)

                    git.push branch, (error) ->
                      endIf(error)

                      git.pushTag tag, (error) ->
                        endIf(error)

                        npm.publish (error) ->
                          endIf(error)

                          log 'success!'

                          # TODO: github release notes
                          # TODO: github PR comments

