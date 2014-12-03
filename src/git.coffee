###
Copyright (c) 2014, Sean Massa
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

Neither the name of GROUPON nor the names of its contributors may be
used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###

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

