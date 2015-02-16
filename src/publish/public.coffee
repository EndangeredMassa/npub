
module.exports = (dir) ->
  packageJson = require "#{dir}/package.json"
  !!packageJson.private

