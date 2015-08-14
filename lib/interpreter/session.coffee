class Session
  constructor: ->
    # Generate a random positive/negative value that simulates the value
    # set in the accumulator in the original RSC program. In the original,
    # the accumulator was undoubtedly set to point to a random memory
    # address and not initialized with any specific value. Whatever
    # "garbage" (pronounced gar-baj) was in the memory location would be
    # converted to a floating point number and displayed. Javascript
    # doesn't use explicit pointers, so such behavior must be simulated.
    @accumulator = (Math.round(Math.random() * Math.pow(10, 6)) / 100) *
      (if Math.random() > 0.5 then -1 else 1)

    # When the RSC program is running, this variable holds the last
    # executed line number.
    @programCounter = 0

    # Whether or not execution should continue. Execution may stop for a
    # number of reasons: STP command encountered, user exited, or error
    # occurred.
    @continue = true

  incrementProgramCounter: ->
    @programCounter += 1

  shouldContinue: ->
    @continue
