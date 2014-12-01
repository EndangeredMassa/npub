npub = require './index'
minimist = require 'minimist'

cli = (argv, directory, config) ->
  command = argv._[0]

  switch command
    when 'prep'
      return npub.prep(directory, config)

    when 'publish'
      version = argv._[1]

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

config = require("#{directory}/package.json").publishConfig
if config?
  delete config.registry
  delete config.tag

cli(argv, directory, config)

