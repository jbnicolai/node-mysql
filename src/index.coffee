# Mysql access
# =================================================
# This package will give you an easy and robust way to access mysql databases.


# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('mysql')
util = require 'util'
path = require 'path'
mysql = require 'mysql'
# include more alinex modules
Config = require 'alinex-config'
# internal helpers
configcheck = require './configcheck'


# Database class
# -------------------------------------------------
class Mysql

  @init: (@config = 'mysql', cb) ->
    debug "init or reinit mysql"
    # set config from different values
    if typeof @config is 'string'
      @config = Config.instance @config
      # add the module's directory as default
      @config.search.unshift path.resolve path.dirname(__dirname), 'var/src/config'
      # add the check methods
      @config.setCheck configcheck
    if @config instanceof Config
      @configClass = @config
      @config = @configClass.data
    @initDone = false # status set to true after initializing
    # set init status if configuration is loaded
    unless @configClass?
      cb() if cb?
      @initDone = true
    else
      # wait till configuration is loaded
      @configClass.load (err) =>
        console.error err if err
        cb err if cb?
        @initDone = true
    config = Config.instance 'database'
    config.setCheck check.database
    config.load cb

  # ### Factory
  # Get an instance for the name. This enables the system to use the same
  # Config instance anywhere.
  @_instances: {}
  @instance: (name) ->
    unless @_instances[name]?
      @_instances[name] = new Mysql name
    @_instances[name]

  # ### Create instance
  # This will also load the data if not already done. Don't call this directly
  # better use the `instance()` method which implements the factory pattern.
  constructor: (@name) ->
    unless name
      throw new Error "Could not initialize Mysql class without database alias."


# Exports
# -------------------------------------------------
# The mysql class is exported directly.
module.exports = Mysql
