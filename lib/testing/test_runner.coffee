class TestRunner
  @TIMEOUT = 2000  # 2 seconds (in milliseconds)

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
    startTime = new Date()
    timeout = false

    counter = 1

    @peripherals.monitor.onValueDisplayed (value) ->
      outputs.push(value)

    until @session.hasStopped() || timeout
      if @session.isWaitingForInput()
        @interpreter.resumeWithInput(@getNextInputValue())
      else
        @interpreter.resume()

      currentTime = new Date()
      timeout = (currentTime - startTime) >= TestRunner.TIMEOUT

    if timeout
      e = new ExecutionTimeoutError('Timeout! Code took too long to execute.')
      Events.fireIfDefined(this, 'onErrorCallback', e)
      []
    else
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
