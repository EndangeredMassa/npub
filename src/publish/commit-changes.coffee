module.exports = (git, version, callback) ->
  git.commit "v#{version}", (success) ->
    if !success
      console.error '[npub] failed to commit changes'
      process.exit(1)
    callback()

