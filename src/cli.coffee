npub = require './index'

cli = (command, dir) ->
  if command == 'prep'
    return npub.prep(dir)
  if command == 'publish'
    return npub.publish(dir)

  console.log "invalid command: #{command}"

command = process.argv[2]
if !command?
  console.log 'command required'
directory = process.argv[3] || process.cwd()
cli(command, directory)
