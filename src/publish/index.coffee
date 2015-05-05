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
      done(null, tempChangelogPath)

    (tempChangelogPath, done) ->
      openEditor tempChangelogPath, (error) ->
        if error?
          fs.unlinkSync tempChangelogPath
          return done(error)

        changelog.update(tempChangelogPath)
        updateVersion(dir, version)
        done()

    (done) ->
      tag = "v#{version}"
      commitChanges git, tag, (error) ->
        done(error, tag)

    (tag, done) ->
      git.tag tag, (error) ->
        done(error, tag)

    (tag, done) ->
      prompt version, (error) ->
        done(error, tag)

    (tag, done) ->
      git.remoteBranch (error, remoteBranch) ->
        [remote, branch] = remoteBranch?.split('/')
        done(error, remote, branch, tag)

    (remote, branch, tag, done) ->
      git.push remote, branch, (error) ->
        done(error, remote, tag)

    (remote, tag, done) ->
      git.pushTag remote, tag, done

    (done) ->
      npm.publish done

  ], (error) ->
    if error?
      log.error error.message
      process.exit(1)

    log 'success!'

