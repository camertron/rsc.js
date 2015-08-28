class TestRunner
  constructor: (programText) ->
    @inputs = []
    @outputs = []
    @numberOfOutputs = 0
    @inputCounter = 0

    @commands = @parseCommandList(programText)
    @session = new Session()
    @peripherals = new TestPeripherals(@session)
    @interpreter = new SteppingInterpreter(
      @commands, @peripherals, @session
    )

    @peripherals.monitor.onValueDisplayed (value) =>
      @outputs.push(value)

    @interpreter.onError (e) ->
      console.log(e.stack)

  setInputs: (@inputs) ->

  setNumberOfOutputs: (@numberOfOutputs) ->

  run: ->
    until @session.hasStopped()
      if @session.isWaitingForInput()
        @interpreter.resumeWithInput(@getNextInputValue())
      else
        @interpreter.resume()

  getNextInputValue: ->
    @inputCounter += 1
    @inputs[@inputCounter - 1]

  parseCommandList: (programText) ->
    commands = CommandList.parse(programText)
    totalCommands = Rsc.defaultNumColumns * Rsc.defaultNumRows

    until commands.length >= totalCommands
      commands.push(null)

    commands

(exports ? @).TestRunner = TestRunner
