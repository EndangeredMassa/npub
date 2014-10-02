git = require './git'

module.exports = (dir, callback) ->
  git.isClean dir, (isClean) ->
    if !isClean
      callback(new Error "git status at #{dir} is not clean")
    callback()

