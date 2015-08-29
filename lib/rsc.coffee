class Rsc
  @defaultNumColumns = 3
  @defaultNumRows = 15

  constructor: (selector, options = {}) ->
    options.commands = @getCommandsFromHash()
    @container = new ContainerView(options)
    $(selector).replaceWith(@container.elem)

    # used by the interpreter
    @session = new Session()
    @refreshAccumulator()

    @container.controls.onRunProgramButtonClicked =>
      if @container.commandList.getErrors().length > 0
        alert(
          'Your program contains one or more syntax errors. ' +
          'Please fix them before running.'
        )

        return

      @session.reset()

      @container.controls.runProgramButton.disable()
      @container.controls.clearMemButton.disable()
      @container.controls.stopButton.enable()
      @container.commandList.disable()

      interpreter = new SteppingInterpreter(
        @container.commandList.getCommands(),
        @container.peripherals, @session
      )

      interpreter.onProgramStep => @refreshInterface(interpreter)
      interpreter.onProgramStop => @resetInterface()

      @container.controls.onStepButtonClicked =>
        if @session.isWaitingForInput()
          # display dialog if user tried to click 'Step' while
          # the system is waiting for input
          alert('Waiting for input...')
        else if @session.shouldContinue()
          interpreter.resume()

      @container.controls.onStopButtonClicked =>
        @resetInterface()

      interpreter.onError (e) => @handleError(e)
      @refreshInterface(interpreter)

      if interpreter.requiresManualStepping()
        @container.controls.stepButton.enable()

      interpreter.start()

    @container.controls.onClearMemButtonClicked =>
      if confirm('Are you sure you want to clear the memory? Your program will be erased.')
        @container.commandList.clear()

    @container.commandList.onItemValidationFinished =>
      @updateUrl()

  refreshInterface: (interpreter) ->
    @refreshExecutionLine()
    @refreshAccumulator()
    @refreshMemoryUI(interpreter)

    if @session.isWaitingForInput()
      @container.peripherals.keyboard.enable()
      @container.peripherals.keyboard.showIndicator()
      @container.peripherals.keyboard.focus()
    else
      @container.peripherals.keyboard.disable()
      @container.peripherals.keyboard.hideIndicator()

  refreshMemoryUI: (interpreter) ->
    # update storage location UI
    interpreter.memory.eachStorageLocation (line, location) =>
      if Utils.isNumeric(location.value)
        @container.commandList.setFieldValueAtIndex(line, location.value)
      else
        @container.commandList.clearFieldValueAtIndex(line)

  refreshExecutionLine: ->
    # show next line to be executed
    @container.commandList.indicateExecutionForLine(
      @session.programCounter
    )

  refreshAccumulator: ->
    @container.peripherals.accumulator.setValue(
      @session.accumulator
    )

  resetInterface: ->
    @container.commandList.reset()
    @container.controls.reset()

  handleError: (e) ->
    switch e.constructor
      when NotExecutableError, NotStorableError, AddressOutOfBoundsError
        alert("#{e.message} Program halted.")
        @resetInterface()
      else
        @resetInterface()
        throw e

  updateUrl: ->
    window?.location.hash = @container.commandList.toBase64()

  getCommandsFromHash: ->
    if window?.location.hash.length > 0
      try
        JSON.parse(atob(window.location.hash.slice(1)))
      catch
        {}
    else
      {}

(exports ? @).Rsc = Rsc
