{exec} = require 'child_process'
debug = require("debug") "test"

module.exports = (dir, log, npm, testCommand, callback) ->
  debug "run"
  options = { dir }

  if testCommand
    debug "exec #{testCommand}"
    exec testCommand, options, (error, stdout, stderr) ->
      log(stdout) if stdout?
      log.error(stderr) if stderr?

      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
        return

      callback()

  else
    npm.test callback
