Package: alinex-mysql
=================================================

[![Build Status] (https://travis-ci.org/alinex/node-mysql.svg?branch=master)](https://travis-ci.org/alinex/node-mysql)
[![Coverage Status] (https://coveralls.io/repos/alinex/node-mysql/badge.png?branch=master)](https://coveralls.io/r/alinex/node-mysql?branch=master)
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

To be written...


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
- connect(cb) - get a connection
- close() - close the database pool
- query(sql, cb) - run sql directly
- queryOne(sql, cb) - get one field only
- queryRow(sql, cb) - get one row as data object
- insertId(sql, cb) - execute query and return last insert id


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
