npub = require './index'

cli = (command, option, directory, config) ->
  switch command
    when 'prep'
      return npub.prep(directory, config)

    when 'publish'
      if !option?
        console.log '<version> required for command: npub publish <version>'
        process.exit(2)
      return npub.publish(directory, option, config)

    else
      console.log "invalid command: \"#{command}\""

command = process.argv[2]
option = process.argv[3]
directory = process.cwd()

config = (require "#{directory}/package.json").publishConfig
if config?
  delete config.registry
  delete config.tag

cli(command, option, directory, config)

