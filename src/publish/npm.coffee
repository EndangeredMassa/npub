{exec} = require 'child_process'
debug = require("debug") "npm"

module.exports = (dir, log) ->
  debug "initialized for: #{dir}"
  options = { dir }

  test: (callback) ->
    debug "test"

    exec "npm test", options, (error, stdout, stderr) ->
      log(stdout) if stdout?
      log.error(stderr) if stderr?

      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
        return

      callback()

  publish: (callback) ->
    debug "publish"

    exec "npm publish", options, (error, stdout, stderr) ->
      log(stdout) if stdout?
      log.error(stderr) if stderr?
      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
        return

      callback()
