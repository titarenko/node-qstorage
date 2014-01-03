qstorage
========

Partial wrapper around [MongoDB API](https://github.com/mongodb/node-mongodb-native) which employs [promises](https://github.com/kriskowal/q) instead of callbacks.

[![Build Status](https://secure.travis-ci.org/titarenko/node-qstorage.png?branch=master)](https://travis-ci.org/titarenko/node-qstorage) [![Coverage Status](https://coveralls.io/repos/titarenko/node-qstorage/badge.png)](https://coveralls.io/r/titarenko/node-qstorage)

[![NPM](https://nodei.co/npm/qstorage.png?downloads=true&stars=true)](https://nodei.co/npm/qstorage/)

Usage
=====

By default `qstorage` lazily connects to MongoDB instance using connection string provided via `CONNECTION_STRING` environment variable.
*If you need to provide connection string via API call, these details will be discussed below.*

So, everything you need, is start directly from inserting, querying and updating your documents!

```coffee
storage = require "qstorage"

storage
	.insert("mydocs", prop1: "val1", prop2: 2)
	.then(-> storage.find("mydocs", prop1: "val1"))
	.then((doc) -> storage.update("mydocs", {prop1: doc.prop1}, {$set: prop2: 3}))
	.then(-> storage.drop("mydocs"))
	.catch((error) -> console.log error)
	.done(-> console.log "Everything is OK!")
```

As you may noticed, `qstorage` API follows promise pattern and for this purpose it uses [Q](https://github.com/kriskowal/q) library. 

License
=======

MIT

