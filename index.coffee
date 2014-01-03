Q = require 'q'
connect = require("./connection").connect

module.exports = 

	insert: (where, what) ->
		connect().then (db) ->
			deferred = Q.defer()
			collection = db.collection(where)
			collection.insert what, (error) ->
				if error
					deferred.reject(error)
				else
					deferred.resolve()
			deferred.promise

	find: (where, query, options) ->
		connect().then (db) ->
			deferred = Q.defer()
			collection = db.collection(where)
			cursor = collection.find(query or {})
			cursor.sort(options.sort) if options?.sort
			cursor.skip(options.skip) if options?.skip
			cursor.limit(options.limit) if options?.limit
			cursor.toArray (error, documents) ->
				if error
					deferred.reject(error)
				else
					deferred.resolve(documents)
			deferred.promise

	update: (where, what, how) ->
		connect().then (db) ->
			deferred = Q.defer()
			collection = db.collection(where)
			options = multi: true, safe: true
			collection.update what, how, options, (error) ->
				if error
					deferred.reject(error)
				else
					deferred.resolve()
			deferred.promise

	drop: (what) ->
		connect().then (db) ->
			deferred = Q.defer()
			collection = db.collection(what)
			collection.drop (error) ->
				if error
					deferred.reject(error)
				else
					deferred.resolve()
			deferred.promise
