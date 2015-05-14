{exec} = require 'child_process'
debug = require('debug') "git"

module.exports = (dir) ->
  debug "initialized for: #{dir}"
  options = { cwd: dir }

  dir: dir

  isClean: (callback) ->
    debug "isClean"

    exec 'git status --untracked-files=all --porcelain', options, (error, stdout, stderror) ->
      callback(stdout.length == 0, stdout?.trim())

  getSha: (callback) ->
    debug 'getSha'
    exec 'git rev-parse HEAD', options, (error, stdout, stderror) ->
      callback(error, stdout?.trim())

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

  remoteBranch: (callback) ->
    debug "remoteBranch"

    exec "git rev-parse --abbrev-ref --symbolic-full-name @{u}", options, (error, stdout, stderr) ->
      callback(error, stdout)

  push: (remote, branch, callback) ->
    debug "push - #{remote} #{branch}"

    exec "git push #{remote} #{branch}", options, (error, stdout, stderror) ->
      callback(error)

  pushTag: (remote, tag, callback) ->
    debug "pushTag - #{remote} #{tag}"

    exec "git push #{remote} tag #{tag}", options, (error, stdout, stderror) ->
      callback(error)

