class Interpreter
  constructor: (@commands, @peripherals, @session) ->
    @memory = @buildMemory(@commands)

  onProgramStep: (callback) ->
    @onProgramStepCallback = callback

  onProgramStop: (callback) ->
    @onProgramStopCallback = callback

  onError: (callback) ->
    @onErrorCallback = callback

  # protected

  getCurrentInstruction: ->
    instruction = @memory.getInstructionAtIndex(
      @session.programCounter
    )

    unless instruction?
      throw new NotExecutableError(
        "The instruction on line #{@session.programCounter + 1} " +
          "is not executable."
      )

    instruction

  buildMemory: (commands) ->
    list = for command in commands
      if command?
        Instruction.fromCommand(command)
      else
        new StorageLocation()

    new Memory(list)
