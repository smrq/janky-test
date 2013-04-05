_ = require 'underscore'

# Janky Test Framework
exports = module.exports =
	test: (name, fn) ->
		->
			testResults = []
			assert =
				ok: (bool, name) ->
					name = "Unnamed test" unless name?
					testResults.push [bool, name]
				equal: (actual, expected, name) ->
					name = "Unnamed test" unless message?
					message = "\nActual:\n#{actual.replace(/\n/g, "\\n\n")}\n\nExpected:\n#{expected.replace(/\n/g, "\\n\n")}"
					testResults.push [_.isEqual(actual, expected), name, message]
			failed = 0
			passed = 0

			console.log "Test: #{name}"
			fn(assert)
			for [result, name, message], i in testResults
				resultText = if result then "Passed" else "Failed"
				console.log "Test '#{name}' #{resultText}"
				console.log message if message?
				if result then passed++ else failed++
			console.log "#{passed} tests passed, #{failed} tests failed"
			console.log ""
			return failed is 0
	module: (name, tests) ->
		console.log "------------------------------------------------"
		console.log name
		console.log "------------------------------------------------"
		console.log ""
		allTestResults = (test() for test in tests)
		passedResults = _(allTestResults).filter((result) -> result).length
		failedResults = _(allTestResults).filter((result) -> not result).length
		console.log "------------------------------------------------"
		console.log "#{passedResults} tests of #{allTestResults.length} passed"
		console.log "#{failedResults} tests of #{allTestResults.length} failed" if failedResults > 0
		console.log "------------------------------------------------"