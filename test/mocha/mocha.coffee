chai = require 'chai'
expect = chai.expect
Config = require 'alinex-config'

Config.search.push 'test/data'

describe "Mysql access", ->
  it "instantiate a mysql database", ->
    console.log Config
  	expect(2+2).is.equal 4

