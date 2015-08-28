class CommandList
	@parse = (text) ->
		chunks = Command.parse(chunk.trim()) for chunk in text.split("\n") when chunk.trim().length > 0
