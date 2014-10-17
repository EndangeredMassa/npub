debug = require('debug') 'clean-stage'

module.exports = (git, callback) ->
  git.isClean (isClean) ->
    debug "isClean: #{isClean}"

    if !isClean
      callback(new Error "git status at #{git.dir} is not clean")
    callback()

