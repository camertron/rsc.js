class NotExecutableError extends Error
  constructor: (message) ->
    @name = 'NotExecutableError'
    @message = message
    @stack = (new Error()).stack
