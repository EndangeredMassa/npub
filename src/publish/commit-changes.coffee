debug = require('debug') 'commit-changes'

module.exports = (git, tag, callback) ->
  debug tag

  git.commit tag, (success) ->
    debug "status: #{success}"

    if !success
      callback(new Error "failed to commit changes")
      return

    callback()

