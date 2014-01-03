index = require "../index"
should = require "should"

process.env.CONNECTION_STRING = "mongodb://localhost/qstream-test"

describe "index", ->

	afterEach (done) ->
		index.drop("smth").done(done)

	describe "::insert()", ->

		it "should insert single instance", (done) ->
			index
				.insert("smth", a: "b")
				.then(-> index.find("smth"))
				.catch(done)
				.done((smth) ->
					should.exist smth
					smth.should.have.lengthOf 1
					done()
				)

	describe "::find()", ->

		it "should find things like MongoDB native client does", (done) ->
			index
				.insert("smth", [
					{a: "b"}
					{a: "c"}
				])
				.then(-> index.find("smth", a: "c"))
				.catch(done)
				.done((smth) ->
					should.exist smth
					smth.should.have.lengthOf 1
					done()
				)

	describe "::update()", ->

		it "should update things like MongoDB native client does", (done) ->
			index
				.insert("smth", [
					{a: "b"}
					{a: "c"}
				])
				.then(-> index.update("smth", {a: "c"}, {$set: a: "d"}))
				.then(-> index.find("smth", a: "d"))
				.catch(done)
				.done((smth) ->
					should.exist smth
					smth.should.have.lengthOf 1
					done()
				)
