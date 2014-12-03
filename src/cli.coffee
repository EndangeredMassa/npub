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

npub = require './index'
minimist = require 'minimist'
semver = require 'semver'

clone = (obj) ->
  JSON.parse(JSON.stringify(obj || {}))

publishVersion = (str, currentVersion) ->
  if !str?
    log.error '<version> required for command: npub publish <version>'
    process.exit(2)

  version = switch str
    when "patch", "minor", "major"
      semver.inc(currentVersion, str)
    else
      semver.valid(str)

  if !version
    log.error "'#{version}' is invalid."
    process.exit(2)

  return version

cli = (argv, directory, packageJson) ->
  command = argv._[0]
  config = clone(packageJson.publishConfig)

  switch command
    when 'prep'
      return npub.prep(directory, config)

    when 'publish'
      version = publishVersion(argv._[1], packageJson.version)
      testCommand = argv.t || argv.test
      return npub.publish(directory, version, testCommand, config)

    when 'verify'
      npub.verify directory, (err) ->
        process.exit(2) if err

    else
      console.log "invalid command: \"#{command}\""

argv = minimist process.argv.slice(2)
directory = process.cwd()

packageJson = require("#{directory}/package.json")
cli(argv, directory, packageJson)

