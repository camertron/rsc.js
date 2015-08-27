class TestPeripherals
	constructor: (session) ->
		@accumulator = new TestAccumulator(session)
		@monitor = new TestMonitor()
		@keyboard = new TestKeyboard()

class TestAccumulator
	constructor: (@session) ->

	getValue: ->
		@session.accumulator

	setValue: (newValue) ->
		@session.accumulator = newValue

class TestMonitor
	constructor: ->
		@value = null

	displayValue: (value) ->
		@value = value

class TestKeyboard
	onInputReceived: (callback) ->
    @onInputReceivedCallback = callback
