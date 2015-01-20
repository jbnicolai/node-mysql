# Mysql access
# =================================================
# This package will give you an easy and robust way to access mysql databases.


# Node Modules
# -------------------------------------------------

# include base modules
debug = require('debug')('mysql')
debugPool = require('debug')('mysql:pool')
debugQuery = require('debug')('mysql:query')
debugResult = require('debug')('mysql:result')
debugData = require('debug')('mysql:data')
debugCom = require('debug')('mysql:com')
chalk = require 'chalk'
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

  # ### Factory
  # Get an instance for the name. This enables the system to use the same
  # Config instance anywhere.
  @_instances: {}
  @instance: (name) ->
    # start initializing, if not done
    unless @_instances[name]?
      @_instances[name] = new Mysql name
    @_instances[name]

  # ### Create instance
  # This will also load the data if not already done. Don't call this directly
  # better use the `instance()` method which implements the factory pattern.
  constructor: (@name) ->
    debug "create #{@name} instance"
    unless name
      throw new Error "Could not initialize Mysql class without database alias."

  connect: (cb) ->
    unless Mysql.initDone?
      return Mysql.init null, =>
        @connect cb
    # instantiate pool if not already done
    unless @pool?
      debugPool "initialize connection pool for #{@name}"
      unless @constructor.config[@name]
        return cb new Error "Given database alias '#{@name}' is not defined in configuration."
      @pool = mysql.createPool @constructor.config[@name]
      @pool.on 'connection', =>
        debugPool "retrieve connection of #{@name} pool"
      @pool.on 'enqueue', =>
        debugPool "waiting for connection of #{@name} pool"
    # get the connection
    @pool.getConnection (err, conn) =>
      if err
        debug "#{err} on connecting to #{@name}"
        err = new Error "#{err.message} on connecting to #{@name} database"
      else
        conn.on 'error', (err) =>
          debug "uncatched #{err} on connection to #{@name}"
          err = new Error "#{err.message} on connection to #{@name} database"
          throw err
        # switch on debugging wih own method
        conn.config.debug = true
        conn._protocol._debugPacket = (incoming, packet) ->
          dir = if incoming then '<--' else '-->'
          #msg = "#{dir} #{packet.constructor.name} " + chalk.grey util.inspect packet
          msg = util.inspect packet
          switch packet.constructor.name
            when 'ComQueryPacket'
              debugQuery "#{msg}"
            when 'ResultSetHeaderPacket', 'FieldPacket', 'EofPacket'
              debugResult "#{packet.constructor.name} #{chalk.grey msg}"
            when 'RowDataPacket'
              debugData msg
            else
              debugCom "#{dir} #{packet.constructor.name} #{chalk.grey msg}"

      cb err, conn

  close: (cb) ->
    debugPool "close connection pool for #{@name}"
    @pool.end (err) =>
      # remove pool instance to be reopened on next use
      @pool = null
      cb err

# Exports
# -------------------------------------------------
# The mysql class is exported directly.
module.exports = Mysql
