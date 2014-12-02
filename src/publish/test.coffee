{exec} = require 'child_process'
debug = require("debug") "test"

module.exports = (dir, npm) ->
  debug "initialized for: #{dir}"
  options = { dir }

  (testCommand, callback) ->
    debug "run"

    if testCommand
      debug "exec #{testCommand}"
      exec testCommand, options, (error, stdout, stderr) ->
        console.log(stdout) if stdout?
        console.log(stderr) if stderr?

        if error?
          callback(new Error "tests failed with exit code: #{error.code}")
          return

        callback()

    else
      npm.test callback
