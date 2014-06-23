{exec} = require 'child_process'

gitCommand = (dir, command, callback) ->
  options = { cwd: dir }
  exec "git " + command, options, callback

module.exports =
  isClean: (dir, callback) ->
    gitCommand dir, 'diff --exit-code', (error, stdout, stderror) ->
      callback(!error)

  commit: (dir, message, callback) ->
    gitCommand dir, " add --all ; git commit -m '#{message}'", (error, stdout, stderror) ->
      callback(!error)

  diffSinceLastTag: (dir, callback) ->
    gitCommand dir, "log --oneline $(git describe --tags --abbrev=0)..HEAD", (error, stdout, stderr) ->
      throw error if error?
      callback(stdout)

  tag: (dir, tag, callback) ->
    console.log 'tagging?'
    gitCommand dir, "tag -a #{tag} -m #{tag}", (error, stdout, stderror) ->
      throw error if error?
      callback()

