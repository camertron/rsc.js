class TestRunner
  constructor: (programText, @inputs) ->
    @inputCounter = 0
    @commands = @parseCommandList(programText)
    @session = new Session()
    @peripherals = new TestPeripherals(@session)
    @interpreter = new SteppingInterpreter(
      @commands, @peripherals, @session
    )

    @interpreter.onError (e) =>
      Events.fireIfDefined(this, 'onErrorCallback', e)

  onError: (callback) ->
    @onErrorCallback = callback

  run: ->
    outputs = []

    @peripherals.monitor.onValueDisplayed (value) ->
      outputs.push(value)

    until @session.hasStopped()
      if @session.isWaitingForInput()
        @interpreter.resumeWithInput(@getNextInputValue())
      else
        @interpreter.resume()

    outputs

  getNextInputValue: ->
    @inputCounter += 1
    @inputs[@inputCounter - 1]

  parseCommandList: (programText) ->
    commands = CommandList.parse(programText)
    totalCommands = Rsc.defaultNumColumns * Rsc.defaultNumRows

    until commands.length >= totalCommands
      commands.push(null)

    commands
