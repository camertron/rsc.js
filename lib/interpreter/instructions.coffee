class Instruction
  @fromCommand = (command) ->
    # @todo: support all commands
    return new Instructions[command.command](command)

  constructor: (@command) ->
  isExecutable: -> true

  getLocation: (memory) ->
    memory.getStorageLocationAtIndex(@command.arg1 - 1)

`var Instructions = {}`

# LDA m
# Load value from location m into accumulator
class Instructions.LDA extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator = @getLocation(memory).value
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
    @getLocation(memory).value = session.accumulator
    session.incrementProgramCounter()

# INP m
# Input value and store at location m
class Instructions.INP extends Instruction
  execute: (session, memory, peripherals) ->
    session.waitingForInput = true
    session.continue = false

  resumeWithInput: (input, session, memory, peripherals) ->
    @getLocation(memory).value = input
    session.waitingForInput = false
    session.continue = true
    session.incrementProgramCounter()

# OUT m
# Output value from location m
class Instructions.OUT extends Instruction
  execute: (session, memory, peripherals) ->
    peripherals.monitor.displayValue(@getLocation(memory).value)
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
    session.accumulator += @getLocation(memory).value
    session.incrementProgramCounter()

# SUB m
# Subtract value from location m from accumulator
class Instructions.SUB extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator -= @getLocation(memory).value
    session.incrementProgramCounter()

# MUL m
# Multiply accumulator by value in location m
class Instructions.MUL extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator *= @getLocation(memory).value
    session.incrementProgramCounter()

# DIV m
# Divide accumulator by value in location m
class Instructions.DIV extends Instruction
  execute: (session, memory, peripherals) ->
    session.accumulator /= @getLocation(memory).value
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
