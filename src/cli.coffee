npub = require './index'

cli = (command, option, directory, config) ->
  if command == 'prep'
    return npub.prep(directory, option, config)
  if command == 'publish'
    return npub.publish(directory, config)

  console.log "invalid command: #{command}"

command = process.argv[2]
option = process.argv[3]
directory = process.cwd()

config = (require "#{directory}/package.json").publishConfig
if config?
  delete config.registry
  delete config.tag

if !command?
  console.log 'command required'
  process.exit(1)

cli(command, option, directory, config)
