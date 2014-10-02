{exec} = require 'child_process'

module.exports = (dir, callback) ->
  options =
    dir: dir

  exec "npm test", dir, (error, stdout, stderr) ->
    console.log(stdout) if stdout?
    console.error(stderr) if stderr?
    if error?
      callback(new Error "tests failed with exit code: #{error.code}")
    callback()

