client = require('mongodb').MongoClient
Q = require 'q'

__connection = null

connect = (connectionString) ->
	deferred = Q.defer()
	if __connection
		deferred.resolve(__connection)
	else
		connectionString = process.env.CONNECTION_STRING unless connectionString
		try
			client.connect connectionString, (error, db) ->
				if error
					deferred.reject(error)
				else
					__connection = db
					deferred.resolve(__connection)
		catch error
			deferred.reject(error)
	deferred.promise

disconnect = ->
	if __connection
		__connection.close()
		__connection = null
	Q()

module.exports =
	connect: connect
	disconnect: disconnect
