# Indicates the program tried to execute an instruction from
# an address that contains a data value.
class NotExecutableError extends Error
  constructor: (message) ->
    @name = 'NotExecutableError'
    @message = message
    @stack = (new Error()).stack

# Indicates the program tried to write a value to a memory
# address that contains an instruction.
class NotStorableError extends Error
  constructor: (message) ->
    @name = 'NotStorableError'
    @message = message
    @stack = (new Error()).stack

# Indicates the program tried to access a memory address
# greater than the total number of allocated addresses.
class AddressOutOfBoundsError extends Error
  constructor: (message) ->
    @name = 'AddressOutOfBoundsError'
    @message = message
    @stack = (new Error()).stack

# Indicates an RSC program has taken too long to execute.
class ExecutionTimeoutError extends Error
  constructor: (message) ->
    @name = 'ExecutionTimeoutError'
    @message = message
    @stack = (new Error()).stack
