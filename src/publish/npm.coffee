{exec} = require 'child_process'

module.exports =
  test: (dir, callback) ->
    options =
      dir: dir

    exec "npm test", options, (error, stdout, stderr) ->
      console.log(stdout) if stdout?
      console.error(stderr) if stderr?
      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
      callback()

  publish: (dir, callback) ->
    options =
      dir: dir

    exec "npm publish", options, (error, stdout, stderr) ->
      console.log(stdout) if stdout?
      console.error(stderr) if stderr?
      if error?
        callback(new Error "tests failed with exit code: #{error.code}")
      callback()

