log = require './log'
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
      return npub.prep(directory, log, config)

    when 'publish'
      version = publishVersion(argv._[1], packageJson.version)
      testCommand = argv.t || argv.test
      return npub.publish(directory, log, config, version, testCommand)

    when 'verify'
      npub.verify directory, (err) ->
        process.exit(2) if err

    else
      log.error "invalid command: \"#{command}\""

argv = minimist process.argv.slice(2)
directory = process.cwd()

packageJson = require("#{directory}/package.json")
cli(argv, directory, packageJson)

