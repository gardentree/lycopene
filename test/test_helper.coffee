path = require('path')

exports.require = (test)->
  root = process.cwd()

  target = null
  if (test.charAt(0) == '/')
    target = "#{root}/assets/#{test.substr(root.length).match(/\/\w+\/(.+)_test\.coffee/)[1]}"
  else
    target = "#{root}/assets/#{test}"

  require(path.relative(__dirname,target))
