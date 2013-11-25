npub = require './index'

cli = (command, dir, cwd, config) ->
  if command == 'prep'
    return npub.prep(dir, cwd, config)
  if command == 'publish'
    return npub.publish(dir, cwd, config)

  console.log "invalid command: #{command}"

command = process.argv[2]
cwd = process.cwd()
directory = process.argv[3] || cwd

config = (require "#{cwd}/package.json").publishConfig
delete config.registry
delete config.tag

if !command?
  console.log 'command required'
  process.exit(1)

cli(command, directory, cwd, config)
