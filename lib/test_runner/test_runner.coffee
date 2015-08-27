class TestRunner
  constructor: (programText) ->
    @commands = CommandList.parse(programText)