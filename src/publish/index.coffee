fs = require 'fs'
async = require 'async'
debug = require('debug') 'publish'

prep = require '../prep'
verify = require '../verify'
Changelog = require './changelog'
openEditor = require './editor'
updateVersion = require './version'
commitChanges = require './commit-changes'
Npm = require './npm'
Git = require '../git'
test = require './test'
prompt = require './prompt'
isPrivate = require './public'


module.exports = (dir, log, config, version, testCommand) ->
  debug "start"

  git = Git(dir)
  npm = Npm(dir, log)
  changelog = Changelog(dir, git)

  if isPrivate(dir)
    log 'cannot publish this package because it is private.'
    process.exit(2)

  async.waterfall [
    (done) ->
      verify dir, done

    (done) ->
      prep(dir, log, config)
      debug 'ensured license headers'
      done()

    (done) ->
      verify dir, done

    (done) ->
      npm.install config.registry, done

    (done) ->
      test dir, log, npm, testCommand, done

    (done) ->
      changelog.build version, done

    (tempChangelog, done) ->
      git.getSha (error, sha) ->
        done(error, tempChangelog, sha)

    (tempChangelog, sha, done) ->
      tempChangelogPath = "/tmp/npub/changelog-#{sha}.md"
      changelog.write(tempChangelog, tempChangelogPath)
      done(null, tempChangeLog)

    (tempChangelogPath, done) ->
      openEditor tempChangelogPath, (error) ->
        if error?
          fs.unlinkSync tempChangelogPath
        changelog.update(tempChangelogPath)
        updateVersion(dir, version)
        done(error)

    (done) ->
      tag = "v#{version}"
      commitChanges git, tag, done

    (done) ->
      git.tag tag, done

    (done) ->
      prompt version, done

    (done) ->
      git.branch(done)

    (branch, done) ->
      git.push branch, done

    (done) ->
      git.pushTag tag, done

    (done) ->
      npm.publish done

  ], (error) ->
    if error?
      log.error error.message
      process.exit(1)

    log 'success!'

