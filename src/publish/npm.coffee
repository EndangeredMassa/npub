{exec} = require 'child_process'
debug = require("debug") "npm"
rimraf = require 'rimraf'
path = require 'path'

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

  install: (registry, callback) ->
    debug "install"

    rimraf path.join(dir, 'node_modules'), (error) ->
      return callback(error) if error?

      registry = if registry
        " --registry=#{registry}"
      else
        ''

      exec "npm install#{registry}", options, (error, stdout, stderr) ->
        log(stdout) if stdout?
        log.error(stderr) if stderr?
        if error?
          callback(new Error "failed to install node modules: #{error.code}")
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
