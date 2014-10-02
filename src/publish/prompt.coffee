readline = require('readline')

module.exports = (version, callback) ->
  prompt = readline.createInterface
    input: process.stdin,
    output: process.stdout

  prompt.question "Publish #{version}? (Y/n) ", (answer) ->
    prompt.close()

    if answer == 'n'
      return callback(new Error 'user aborted publish')

    callback()

