{exec} = require 'child_process'
debug = require("debug") "npm"

module.exports = (dir) ->
  debug "initialized for: #{dir}"
  options = { dir }

  test: (callback) ->
    debug "test"

    exec "npm test", options, (error, stdout, stderr) ->
      console.log(stdout) if stdout?
      console.error(stderr) if stderr?

      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
        return

      callback()

  publish: (callback) ->
    debug "publish"

    exec "npm publish", options, (error, stdout, stderr) ->
      console.log(stdout) if stdout?
      console.error(stderr) if stderr?
      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
        return

      callback()
