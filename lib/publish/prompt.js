// Generated by CoffeeScript 2.0.0-beta7
void function () {
  var debug, readline;
  readline = require('readline');
  debug = require('debug')('prompt');
  module.exports = function (version, callback) {
    var prompt;
    debug(version);
    prompt = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });
    return prompt.question('Publish ' + version + '? (Y/n) ', function (answer) {
      debug('status: ' + answer);
      prompt.close();
      if (answer === 'n')
        return callback(new Error('user aborted publish'));
      return callback();
    });
  };
}.call(this);