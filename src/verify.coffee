debug = require('debug') 'clean-stage'
Git = require './git'

module.exports = (dir, callback) ->
  git = Git(dir)

  git.isClean (isClean, dirtyFiles) ->
    debug "isClean: #{isClean}"

    if !isClean
      err = new Error """
        git status at #{git.dir} is not clean.
        Uncommitted file changes are:
        #{dirtyFiles}"
      """

    callback(err)
