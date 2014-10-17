fs = require 'fs'
debug = require('debug') 'publish'

log = require '../log'
license = require './license'
ensureCleanStage = require './clean-stage'
Changelog = require './changelog'
openEditor = require './editor'
updateVersion = require './version'
commitChanges = require './commit-changes'
Npm = require './npm'
Git = require './git'
prompt = require './prompt'

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

module.exports = (dir, version, config) ->
  debug "start"

  git = Git(dir)
  npm = Npm(dir)
  changelog = Changelog(dir, git)

  ensureCleanStage git, (error) ->
    endIf(error)

    license(dir, config)
    debug 'ensured license headers'

    ensureCleanStage git, (error) ->
      endIf(error)

      npm.test (error) ->
        debug 'ran: npm test'
        endIf(error)

        changelog.build (error, tempChangelog) ->
          endIf(error)

          tempChangelogPath = changelog.write(tempChangelog)
          debug "temp changelog at: #{tempChangelogPath}"

          openEditor tempChangelogPath, (error) ->
            if error?
              fs.unlinkSync tempChangelogPath
              endIf(error)

            changelog.update(tempChangelogPath)
            debug "updated changelog"

            updateVersion(dir, version)
            debug "updated version"

            commitChanges git, version, ->
              debug 'changes committed'

              tag = "v#{version}"

              git.tag tag, (error) ->
                endIf(error)

                debug "tagged: #{tag}"

                prompt version, (error) ->
                  endIf(error)

                  git.branch (error, branch) ->
                    endIf(error)

                    debug "git branch: #{branch}"

                    git.push branch, (error) ->
                      endIf(error)

                      debug "git pushed"

                      git.pushTag tag, (error) ->
                        endIf(error)

                        debug "git tag \"#{tag}\" pushed"

                        npm.publish (error) ->
                          endIf(error)

                          debug "published"

                          log 'success!'

                          # TODO: github release notes
                          # TODO: github PR comments

