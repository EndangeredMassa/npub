###
Copyright (c) 2013, Sean Massa
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

