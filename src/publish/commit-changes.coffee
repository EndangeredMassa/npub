debug = require('debug') 'commit-changes'

module.exports = (git, version, callback) ->
  debug "v#{version}"

  git.commit "v#{version}", (success) ->
    debug "status: #{success}"

    if !success
      console.error '[npub] failed to commit changes'
      process.exit(1)
    callback()

