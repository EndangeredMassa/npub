{exec} = require 'child_process'
debug = require('debug') "git"

module.exports = (dir) ->
  debug "initialized for: #{dir}"
  options = { cwd: dir }

  dir: dir

  isClean: (callback) ->
    debug "isClean"

    exec 'git diff --exit-code', options, (error, stdout, stderror) ->
      callback(!error)

  commit: (message, callback) ->
    debug "commit - #{message}"

    exec "git add CHANGELOG.md package.json && git commit -m '#{message}'", options, (error, stdout, stderror) ->
      callback(!error)

  diffSinceLastTag: (callback) ->
    debug "diffSinceLastTag"

    exec "git log --oneline $(git describe --tags --abbrev=0)..HEAD", options, (error, stdout, stderr) ->
      callback(error, stdout)

  tag: (tag, callback) ->
    debug "tag - #{tag}"

    exec "git tag -a #{tag} -m #{tag}", options, (error, stdout, stderror) ->
      callback(error)

  branch: (callback) ->
    debug "branch"

    exec "git rev-parse --abbrev-ref HEAD", options, (error, stdout, stderr) ->
      callback(error, stdout)

  push: (branch, callback) ->
    debug "push - #{branch}"

    exec "git push origin #{branch}", options, (error, stdout, stderror) ->
      callback(error)

  pushTag: (tag, callback) ->
    debug "pushTag - #{tag}"

    exec "git push origin tag #{tag}", options, (error, stdout, stderror) ->
      callback(error)

