class Interpreter
  constructor: (@peripherals) ->

  interpret: (commands) ->
    memory = @buildMemory(commands)
    session = new Session()

    while session.shouldContinue()
      currentInstruction = memory.getInstructionAtIndex(
        session.programCounter
      )

      currentInstruction.execute(session, memory, @peripherals)

  # protected

  buildMemory: (commands) ->
    list = for command in commands
      if command?
        Instruction.fromCommand(command)
      else
        new StorageLocation()

    new Memory(list)
