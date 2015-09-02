class Instruction
  @fromCommand = (command) ->
    return new Instructions[command.command](command)

  constructor: (@command) ->
  isExecutable: -> true

  getLocation: (memory) ->
    address = @command.arg1 - 1

    if address >= memory.values.length
      throw new AddressOutOfBoundsError(
        "Attempted to access memory address " +
          "#{@command.arg1}, which doesn't exist."
      )

    location = memory.getStorageLocationAtIndex(address)

    unless location
      throw new NotStorableError(
        "Attempted to store a value in location #{@command.arg1}, " +
          "which contains an instruction."
      )

    location

  readLocation: (memory) ->
    location = @getLocation(memory)

    unless location.value?
      throw new NotStorableError(
        "Attempted to read the value of location #{@command.arg1}, " +
          "which doesn't contain a value."
      )

    location.value

  writeLocation: (memory, value) ->
    @getLocation(memory).value = value

`var Instructions = {}`

# LDA m
# Load value from location m into accumulator
class Instructions.LDA extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator = @readLocation(memory)
    session.incrementProgramCounter()

# LDC i
# Load constant value i into accumulator
class Instructions.LDC extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator = @command.arg1
    session.incrementProgramCounter()

# STA m
# Store accumulator at location m
class Instructions.STA extends Instruction
  execute: (session, memory, peripherals) ->
    @writeLocation(memory, session.accumulator)
    session.incrementProgramCounter()

# INP m
# Input value and store at location m
class Instructions.INP extends Instruction
  execute: (session, memory, peripherals) ->
    session.waitingForInput = true
    session.continue = false

  resumeWithInput: (input, session, memory, peripherals) ->
    @writeLocation(memory, input)
    session.waitingForInput = false
    session.continue = true
    session.incrementProgramCounter()

# OUT m
# Output value from location m
class Instructions.OUT extends Instruction
  execute: (session, memory, peripherals) ->
    peripherals.monitor.displayValue(@readLocation(memory))
    session.incrementProgramCounter()

# ADC i
# Add constant value i to accumulator
class Instructions.ADC extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator += @command.arg1
    session.incrementProgramCounter()

# ADD m
# Add value from location m to accumulator
class Instructions.ADD extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator += @readLocation(memory)
    session.incrementProgramCounter()

# SUB m
# Subtract value from location m from accumulator
class Instructions.SUB extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator -= @readLocation(memory)
    session.incrementProgramCounter()

# MUL m
# Multiply accumulator by value in location m
class Instructions.MUL extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator *= @readLocation(memory)
    session.incrementProgramCounter()

# DIV m
# Divide accumulator by value in location m
class Instructions.DIV extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator /= @readLocation(memory)
    session.incrementProgramCounter()

# BRU m
# Branch to location m
class Instructions.BRU extends Instruction
  execute: (session, memory, peripherals) ->
    session.programCounter = @command.arg1 - 1

# BPA m
# Branch to location m if accumulator is positive
class Instructions.BPA extends Instruction
  execute: (session, memory, peripherals) ->
    if session.accumulator > 0
      session.programCounter = @command.arg1 - 1
    else
      session.incrementProgramCounter()

# BNA m
# Branch to location m if accumulator is negative
class Instructions.BNA extends Instruction
  execute: (session, memory, peripherals) ->
    if session.accumulator < 0
      session.programCounter = @command.arg1 - 1
    else
      session.incrementProgramCounter()

# BZA m
# Branch to location m if accumulator is equal to zero
class Instructions.BZA extends Instruction
  execute: (session, memory, peripherals) ->
    if session.accumulator == 0
      session.programCounter = @command.arg1 - 1
    else
      session.incrementProgramCounter()

# Stop execution
class Instructions.STP extends Instruction
  execute: (session, memory, peripherals) ->
    session.continue = false
    session.stopped = true
    session.incrementProgramCounter()
