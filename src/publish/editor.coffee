editor = require 'editor'
debug = require('debug') "editor"

module.exports = (filePath, callback) ->
  debug filePath

  editor filePath, (exitCode) ->
    debug "status: #{exitCode}"

    if exitCode != 0
      callback(new Error "editor exited editor with #{exitCode}; aborting")
    callback()

