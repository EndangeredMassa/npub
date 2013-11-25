npub = require './index'

directory = process.cwd()

cli = (command) ->
  if command == 'prep'
    return npub.prep(directory)
  if command == 'publish'
    return npub.publish(directory)

  console.log "invalid command: #{command}"

command = process.argv[2]
if !command?
  console.log 'command required'
cli(command)
