client = require("mongodb").MongoClient

originalConnect = client.connect
lastConnectionString = null

module.exports =

	mockMongoConnect: (func) ->
		if not func
			func = (connectionString, callback) ->
				lastConnectionString = connectionString
				callback(null, close: ->)
		client.connect = func

	restoreMongoConnect: ->
		client.connect = originalConnect

	getLastConnectionString: ->
		lastConnectionString
