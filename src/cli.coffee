npub = require './index'

cli = (command, option, directory, config) ->
  if command == 'version'
    if !option?
      console.log '<version> required for command: npub version <version>'
      process.exit(2)
    return npub.publish(directory, option, config)

  console.log "invalid command: \"#{command}\""

command = process.argv[2]
option = process.argv[3]
directory = process.cwd()

config = (require "#{directory}/package.json").publishConfig
if config?
  delete config.registry
  delete config.tag

cli(command, option, directory, config)

