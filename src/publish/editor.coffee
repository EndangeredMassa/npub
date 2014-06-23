editor = require 'editor'

module.exports = (filePath, callback) ->
  editor filePath, (exitCode) ->
    if exitCode != 0
      console.error "[npub] exited editor with #{exitCode}; aborting"
      process.exit(exitCode)
    callback()

