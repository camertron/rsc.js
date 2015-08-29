class SteppingInterpreter extends Interpreter
  constructor: (@commands, @peripherals, @session) ->
    super(@commands, @peripherals, @session)

    @peripherals.keyboard.onInputReceived (input) =>
      @resumeWithInput(input)

  start: ->
    # do nothing - interpreter should pause and wait for resume()
    # to be called

  resume: ->
    try
      if @session.shouldContinue()
        @getCurrentInstruction().execute(
          @session, @memory, @peripherals
        )

        Events.fireIfDefined(@, 'onProgramStepCallback')

      if @session.hasStopped()
        Events.fireIfDefined(@, 'onProgramStopCallback')
    catch e
      @session.stopped = true
      Events.fireIfDefined(@, 'onErrorCallback', e)

  resumeWithInput: (input) ->
    if @session.isWaitingForInput()
      try
        currentInstruction = @getCurrentInstruction()
        currentInstruction.resumeWithInput(
          input, @session, @memory, @peripherals
        )

        Events.fireIfDefined(@, 'onProgramStepCallback')
      catch e
        @session.stopped = true
        Events.fireIfDefined(@, 'onErrorCallback', e)

  requiresManualStepping: ->
    true
