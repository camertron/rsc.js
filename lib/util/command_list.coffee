class CommandList
  @parse = (text) ->
    for chunk in text.split("\n")
      if chunk.trim().length > 0
        Command.parse(chunk.trim())
      else
        null
