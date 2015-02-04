Version changes
=================================================

The following list gives a short overview about what is changed between
individual versions:

Version 0.0.3 (2015-02-04)
-------------------------------------------------
- Throw error if one got from the database.

Version 0.0.2 (2015-01-26)
-------------------------------------------------
- Added method to query one row.
- Added debug output for overall close() method.
- Fix bug in checking for connection errors on queryOne.
- Added global close method working on all database connection pools.
- Added connection thread id for debugging.
- Implemented shortcut methods.
- Exposing sql creation helper directly in class.
- Changed wording in debug output.
- Fixed bug in creating a connection.
- Optimized error handling.
- Be more graceful for dependent packages.

Version 0.0.1 (2015-01-19)
-------------------------------------------------
- Works with simple select query.
- Add configuration structure.
- Initial commit

