class SteppingInterpreter extends Interpreter
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
      Events.fireIfDefined(@, 'onErrorCallback', e)

  requiresManualStepping: ->
    true
