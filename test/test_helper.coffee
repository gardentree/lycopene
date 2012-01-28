exports.require = (test)->
  path = require('path')
  require(path.relative(
     __dirname
    ,"#{path.dirname(__dirname)}/assets/#{test.substr(process.cwd().length).match(/\/\w+\/(.+)_test\.coffee/)[1]}.coffee"
  ))
