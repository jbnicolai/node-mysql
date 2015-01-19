# Check definitions
# =================================================
# This contains configuration definitions for the
# [alinex-validator](http://alinex.github.io/node-validator).

# Mediacenter database
# -------------------------------------------------
access =
  title: "Access Settings"
  description: "the settings used to connect to the database"
  type: 'object'
  allowedKeys: true
  entries:
    type:
      title: "Type of Database"
      description: "shortname of the database type"
      type: 'string'
      values: ['mysql']
    host:
      title: "Hostname"
      description: "the hostname or ip address to connect to"
      type: 'hostname'
      default: 'localhost'
    port:
      title: "Port"
      description: "the port mysql is listening"
      type: 'integer'
      default: 3306
    database:
      title: "Database Name"
      description: "the name of the database to use"
      type: 'string'
    user:
      title: "Username"
      description: "the name used to log into the database"
      type: 'string'
      optional: true
    password:
      title: "Password"
      description: "the password to login"
      type: 'string'
      optional: true
    charset:
      title: "Default Charset"
      description: "the charset used if no other given"
      type: 'string'
      optional: true
    timezone:
      title: "Timezone"
      description: "the timezone to use"
      type: 'string'
      optional: true
    connectionTimeout:
      title: "Connection Timeout"
      description: "the time till a connection could be established"
      type: 'interval'
      unit: 'ms'
      optional: true
    connectionLimit:
      title: "Connection Pool Limit"
      description: "the maximum number of parallel used connections"
      type: 'integer'
      default: 10

cluster = {}

# Export objects
# -------------------------------------------------
module.exports =
  title: "Database Configuration"
  description: "the settings used for accessing the mysql databases"
  type: 'object'
  entries: access

