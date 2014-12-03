###
Copyright (c) 2014, Sean Massa
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

Neither the name of GROUPON nor the names of its contributors may be
used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###

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

module.exports = (dir, log, config, version, testCommand) ->
  debug "start"

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

  git = Git(dir)
  npm = Npm(dir, log)
  changelog = Changelog(dir, git)

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

