editor = require 'editor'

module.exports = (filePath, callback) ->
  editor filePath, (exitCode) ->
    if exitCode != 0
      callback(new Error "editor exited editor with #{exitCode}; aborting")
    callback()

