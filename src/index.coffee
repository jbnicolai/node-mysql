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
SqlString = require 'mysql/lib/protocol/SqlString'
async = require 'async'
# include more alinex modules
Config = require 'alinex-config'
# internal helpers
configcheck = require './configcheck'

# Database class
# -------------------------------------------------
class Mysql

  # sql creation helpers
  @escape: SqlString.escape
  @escapeId: SqlString.escapeId
  @format: SqlString.format

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

  @close: (cb = ->) ->
    debug "Close all database connections..."
    async.each Object.keys(@_instances), (name, cb) =>
      @_instances[name].close cb
    , cb

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
      @pool.on 'connection', (conn) =>
        debugPool "[#{@name}##{conn.threadId}] retrieve connection"
      @pool.on 'enqueue', =>
        debugPool "[#{@name}] waiting for connection"
    # get the connection
    @pool.getConnection (err, conn) =>
      if err
        debug chalk.grey("[#{@name}]") + " #{err} while connecting"
        return cb new Error "#{err.message} while connecting to #{@name} database"
      conn.name = chalk.grey "[#{@name}##{conn.threadId}]"
      conn.on 'error', (err) =>
        debug "#{conn.name} uncatched #{err} on connection"
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
            debugQuery "#{conn.name} #{msg}"
          when 'ResultSetHeaderPacket', 'FieldPacket', 'EofPacket'
            debugResult "#{conn.name} #{packet.constructor.name} #{chalk.grey msg}"
          when 'RowDataPacket'
            debugData "#{conn.name} #{msg}"
          when 'ComQuitPacket'
            debugPool "#{conn.name} close connection"
          else
            debugCom "#{conn.name} #{dir} #{packet.constructor.name} #{chalk.grey msg}"
      release = conn.release
      conn.release = =>
        debugPool "#{conn.name} release connection to #{@name}"
        release()
      # error management
      if packet.constructor.name is 'ErrorPacket'
        return cb new Error "MySQL Error: #{packet.message} (MySQL Error #{packet.errno})"
      # return the connection
      cb null, conn

  close: (cb = ->) =>
    debugPool "close connection pool for #{@name}"
    @pool.end (err) =>
      # remove pool instance to be reopened on next use
      @pool = null
      cb err

  # Shortcut functions
  # -------------------------------------------------

  query: (sql, cb) ->
    @connect (err, conn) ->
      return cb err if err
      conn.query sql, (err, result) ->
        conn.release()
        cb err, result

  queryOne: (sql, cb) ->
    @query sql, (err, result) ->
      return cb err unless result?.length
      unless result[0]? or Object.keys result[0]
        cb err, null
      cb err, result[0][Object.keys(result[0])]

  queryRow: (sql, cb) ->
    @query sql, (err, result) ->
      return cb err unless result?.length
      unless result[0]? or Object.keys result[0]
        cb err, null
      cb err, result[0]

  insertId: (sql, cb) ->
    @connect (err, conn) ->
      return cb err if err
      conn.query sql, (err, result) ->
        conn.release()
        cb err, result.insertId


# Exports
# -------------------------------------------------
# The mysql class is exported directly.
module.exports = Mysql
