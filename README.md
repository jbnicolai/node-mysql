Package: alinex-mysql
=================================================

[![Dependency Status] (https://gemnasium.com/alinex/node-mysql.png)](https://gemnasium.com/alinex/node-mysql)

A simple mysql access wrapper which will leverage the integration of a mysql
database into an alinex based application.

- full configurable
- connection pooling
- integrated debug possibilities
- short method calls

It is one of the modules of the [Alinex Universe](http://alinex.github.io/node-alinex)
following the code standards defined there.


Install
-------------------------------------------------

The easiest way is to let npm add the module directly:

    > npm install alinex-mysql --save

[![NPM](https://nodei.co/npm/alinex-mysql.png?downloads=true&stars=true)](https://nodei.co/npm/alinex-mysql/)


Usage
-------------------------------------------------

First you have to include the module:

    Mysql = require('alinex-mysql');

The complete setup for the database connection is done smoothly in the background
using the [alinex-config](http://alinex.github.io/node-config) module with the
`mysql.yml` file as default. If you have it in another file call:

    Mysql.init(config);

The `config` here may be a name or the configuration structure.

After that you setup the database by giving an database alias which is set in the
configuration:

    db = Mysql.instance('test');

Now you may directly execute some queries with the shortcut methods:

    db.queryOne("SELECT COUNT(*) FROM mc_product", function(err, num) {
      if (err) {
        return cb(err);
      }
      // do something with the `num`
    });

### Placeholders

You may also use placeholders which will smartly be replaced before executing the query.
You won't need to encode them also.

    db.queryOne('SELECT ID FROM product WHERE alias = ?', 'tomato', function(err, result) {
      if (err) {
        return cb(err);
      }
      // do something with the `result`
    });

And if you have multiple placeholders give an array:

    db.queryOne("SELECT md5 FROM file WHERE productID = ? AND file = ?",
    [productID, path.basename(file)], function(err, checksumDb) {
      if (err) {
        return cb(err);
      }
      // do something with the `esult`
    });

And at last you may give an object to be set as placeholder:

    db.insertId("INSERT INTO file SET ?", {
      productID: productID,
      ready: 1,
      name: name,
      dir: "anydir/",
    }, function(err, fileID) {
      if (err) {
        return cb(err);
      }
      // go on and use the just created `fileID`
    });

There are some more short methods you may use. see in the API below.


Configuration
-------------------------------------------------
The configuration contains a list of named database connections each with the
following entries:

- host - the hostname or ip address to connect to
- port - the port mysql is listening (default: 3306)
- database - the name of the database to use
- user - the name used to log into the database
- password - the password to login
- charset - the charset used if no other given
- timezone - the timezone to use
- connectTimeout - the time till a connection should be established
- connectionLimit - the maximum number of parallel used connections


API
-------------------------------------------------

### Class

- init(name) - to be called initially, optional
- instance(name) - to get an instance
- escape(value) - to escape a value properly
- escapeId(value) - to escape query identifiers
- format(sql, vals) - to inject values into parameterized query
- close(cb) - close all database connection pools

### Instances

- name - gives the alias name of the database pool
- close() - close the database pool
- connect(cb) - get a connection
- query(sql, data, cb) - run sql directly
- queryOne(sql, data, cb) - get one field only
- queryRow(sql, data, cb) - get one row as data object
- insertId(sql, data, cb) - execute query and return last insert id


License
-------------------------------------------------

Copyright 2015 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
