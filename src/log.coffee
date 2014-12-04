log = (message) ->
  console.log "[npub] #{message}"

log.error = (message) ->
  console.error "[npub] #{message}"

module.exports = log

