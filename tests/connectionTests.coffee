should = require "should"
utils = require "./utils"
connection = require "../connection"

describe "connection", ->

	describe "::connect()", ->

		afterEach ->
			utils.restoreMongoConnect()
			connection.disconnect()

		it "should return db instance", (done) ->
			utils.mockMongoConnect()
			connection.connect("mongodb://localhost/qstorage-test")
				.then((db) ->
					should.exist db
					db.should.be.ok
					utils.getLastConnectionString().should.eql "mongodb://localhost/qstorage-test"
					done()
				)
				.catch(done)

		it "should fail in Q-style if connection string is wrong", (done) ->
			utils.mockMongoConnect -> throw new Error "Any error."
			connection.connect("https://google.com")
				.then((db) ->
					done new Error "Wow! It has connected to Google as a MongoDB instance!"
				)
				.catch((error) ->
					should.exist error
					done()
				)

		it "should reuse connection instance while is being called multiple times", (done) ->
			originalInstance = null
			utils.mockMongoConnect()
			connection.connect("mongodb://localhost/qstorage-test")
				.then((db) ->
					originalInstance = db
					connection.connect("mongodb://localhost/qstorage-test")
				)
				.then((db) ->
					db.should.equal originalInstance
					done()
				)
				.catch(done)

		it "should use CONNECTION_STRING environment variable if no argument is provided", (done) ->
			process.env.CONNECTION_STRING = "mongodb://localhost/qstorage-test"
			utils.mockMongoConnect()
			connection.connect()
				.then((db) ->
					should.exist db
					db.should.be.ok
					utils.getLastConnectionString().should.eql "mongodb://localhost/qstorage-test"
					done()
				)
				.catch(done)

		it "should fail if native client connection trial was failed", (done) ->
			utils.mockMongoConnect (cs, cb) -> cb new Error "Any error."
			connection.connect("mongodb://google.com")
				.then((db) ->
					done new Error "No way! Google provides MongoDB instance on google.com!"
				)
				.catch((error) ->
					should.exist error
					done()
				)
