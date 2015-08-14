class Memory
  constructor: (@values) ->

  getInstructionAtIndex: (index) ->
    instruction = @values[index]
    if instruction? && instruction.isExecutable()
      instruction
    else
      null

  getStorageLocationAtIndex: (index) ->
    location = @values[index]
    if location? && !location.isExecutable()
      location
    else
      null
