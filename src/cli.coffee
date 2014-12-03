npub = require './index'
minimist = require 'minimist'
semver = require 'semver'

publishVersion = (str, version) ->
  switch str
    when "patch", "minor", "major"
      semver.inc(version, str)
    else
      semver.valid(str)

cli = (argv, directory, packageJson) ->
  command = argv._[0]
  config = JSON.parse(JSON.stringify(packageJson.publishConfig || {}))

  switch command
    when 'prep'
      return npub.prep(directory, config)

    when 'publish'
      version = publishVersion(argv._[1], packageJson.version)

      if !version?
        console.log '<version> required for command: npub publish <version>'
        process.exit(2)

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

