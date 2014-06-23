git = require './git'

module.exports = (dir, version, callback) ->
  git.commit dir, "v#{version}", (success) ->
    if !success
      console.error '[npub] failed to commit changes'
      process.exit(1)
    callback()

