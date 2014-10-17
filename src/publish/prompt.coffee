readline = require('readline')
debug = require('debug') 'prompt'

module.exports = (version, callback) ->
  debug version

  prompt = readline.createInterface
    input: process.stdin,
    output: process.stdout

  prompt.question "Publish #{version}? (Y/n) ", (answer) ->
    debug "status: #{answer}"

    prompt.close()

    if answer == 'n'
      return callback(new Error 'user aborted publish')

    callback()

