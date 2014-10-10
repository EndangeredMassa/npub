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

debug = (message) ->
  # TODO: pull in node-debug?
  # console.log '!%!%', message

module.exports = (dir, version, config) ->
  ensureCleanStage dir, (error) ->
    endIf(error)

    license(dir, config)
    debug 'ensured license headers'

    ensureCleanStage dir, (error) ->
      endIf(error)

      npm.test dir, (error) ->
        endIf(error)

        debug 'ran: npm test'

        changelog.build dir, (error, tempChangelog) ->
          endIf(error)

          tempChangelogPath = changelog.write(dir, tempChangelog)
          debug "temp changelog at: #{tempChangelogPath}"

          openEditor tempChangelogPath, (error) ->
            if error?
              fs.unlinkSync tempChangelogPath
              endIf(error)

            changelog.update(dir, tempChangelogPath)
            debug "updated changelog"

            updateVersion(dir, version)
            debug "updated version"

            commitChanges dir, version, ->
              debug 'changes committed'

              tag = "v#{version}"

              git.tag dir, tag, (error) ->
                endIf(error)

                debug "tagged: #{tag}"

                prompt version, (error) ->
                  endIf(error)

                  git.push dir, (error) ->
                    endIf(error)

                    debug "git pushed"

                    git.pushTag dir, tag, (error) ->
                      endIf(error)

                      debug "git tag \"#{tag}\" pushed"

                      npm.publish dir, (error) ->
                        endIf(error)

                        debug "published"

                        console.log 'success!'

                        # TODO: github release notes
                        # TODO: github PR comments

