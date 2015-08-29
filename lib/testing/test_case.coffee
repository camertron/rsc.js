class TestCase
  constructor: (@program, @testFunc) ->
    @inputs = []
    @expectedOutputs = []
    @succeeded = undefined
    @message = ''

  run: ->
    @testFunc(@)

    @succeeded = true
    runner = new TestRunner(@program, @inputs)
    actualOutputs = runner.run()

    if actualOutputs.length != @expectedOutputs.length
      @succeeded = false
    else
      for actualOutput, idx in actualOutputs
        if Math.abs(actualOutput - @expectedOutputs[idx]) >= 0.1
          @succeeded = false

    unless @succeeded
      @message = "Expected #{JSON.stringify(actualOutputs)} " +
        "to match #{JSON.stringify(@expectedOutputs)}"

  setInputs: (@inputs) ->

  setOutputs: (@expectedOutputs) ->

  didSucceed: ->
    @succeeded

(exports ? @).runTestCase = (program, testFunc) ->
  testCase = new TestCase(program, testFunc)
  testCase.run()
  testCase
