{exec} = require 'child_process'

module.exports = (dir) ->
  options = { dir }

  test: (callback) ->
    exec "npm test", options, (error, stdout, stderr) ->
      console.log(stdout) if stdout?
      console.error(stderr) if stderr?
      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
      callback()

  publish: (callback) ->
    exec "npm publish", options, (error, stdout, stderr) ->
      console.log(stdout) if stdout?
      console.error(stderr) if stderr?
      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
      callback()

