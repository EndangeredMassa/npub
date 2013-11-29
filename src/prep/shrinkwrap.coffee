temp = require 'temp'
fs = require 'fs'
log = require '../log'
{spawn} = require 'child_process'

move = (directories, sourceDirectory, targetDirectory) ->
  for dependency in directories
    source = "#{sourceDirectory}/#{dependency}"
    target = "#{targetDirectory}/#{dependency}"
    fs.renameSync source, target

shrinkwrap = (directory, callback) ->
  log 'shrinkwrap (ignoring but preserving devDependencies)'
  npmProcess = spawn 'npm', ['shrinkwrap'],
    cwd: directory
    stdio: 'inherit'

  npmProcess.on 'exit', callback

getDevDependencies = (directory) ->
  {devDependencies} = require "#{directory}/package.json"
  return undefined unless devDependencies?

  Object.keys devDependencies

# some older versions of npm wouldn't handle
# devDependencies properly;
# this ensures that they are not included in the shrinkwrap
module.exports = (directory, done) ->
  devDependencies = getDevDependencies(directory)

  tempDirectory = null
  nodeModules = "#{directory}/node_modules"

  if devDependencies?
    tempDirectory = temp.mkdirSync {prefix: '.npub'}
    move devDependencies, nodeModules, tempDirectory

  shrinkwrap directory, (exitCode) ->
    if devDependencies?
      move devDependencies, tempDirectory, nodeModules
    done()

