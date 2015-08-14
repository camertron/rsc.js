class Command
  @parse = (text) ->
    tokens = @tokenize(@sanitize(text))
    new Command(tokens[0], tokens[1])

  @sanitize = (text) ->
    text
      .trim()                # remove leading and trailing spaces
      .replace(/\s+/g, ' ')  # compress runs of spaces
      .toUpperCase()         # convert to uppercase

  @tokenize = (text) ->
    text.split(' ')

  constructor: (@command, arg1) ->
    @properties = Commands.get(@command)
    @arg1 = parseFloat(arg1) if arg1?
    @resetErrors()

  isValid: ->
    @setErrors()
    @errors.length == 0

  resetErrors: ->
    @errors = []

  setErrors: ->
    @resetErrors()
    @checkCommandExists() &&
      @checkValidArity() &&
      @checkArgNumericality()

  checkCommandExists: ->
    unless @properties?
      @errors.push("'#{@command}' is not a valid command.")
      false
    else
      true

  checkValidArity: ->
    unless @hasValidArity()
      @errors.push(@properties.errors.wrongArity)
      false
    else
      true

  checkArgNumericality: ->
    if @arity() > 0
      if !isNaN(parseFloat(@arg1)) && isFinite(@arg1)
        true
      else
        @errors.push("The argument following #{@command} must be a number.")
        false
    else
      true

  arity: ->
    if @arg1? then 1 else 0

  hasValidArity: ->
    @properties.arity == @arity()
