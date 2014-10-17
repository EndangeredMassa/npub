{exec} = require 'child_process'

module.exports = (dir) ->
  options = { cwd: dir }

  dir: dir

  isClean: (callback) ->
    exec 'git diff --exit-code', options, (error, stdout, stderror) ->
      callback(!error)

  commit: (message, callback) ->
    exec "git add CHANGELOG.md package.json && git commit -m '#{message}'", options, (error, stdout, stderror) ->
      callback(!error)

  diffSinceLastTag: (callback) ->
    exec "git log --oneline $(git describe --tags --abbrev=0)..HEAD", options, (error, stdout, stderr) ->
      callback(error, stdout)

  tag: (tag, callback) ->
    exec "git tag -a #{tag} -m #{tag}", options, (error, stdout, stderror) ->
      callback(error)

  branch: (callback) ->
    exec "git rev-parse --abbrev-ref HEAD", options, (error, stdout, stderr) ->
      callback(error, stdout)

  push: (branch, callback) ->
    exec "git push origin #{branch}", options, (error, stdout, stderror) ->
      callback(error)

  pushTag: (tag, callback) ->
    exec "git push origin tag #{tag}", options, (error, stdout, stderror) ->
      callback(error)
