class TestRunner
  constructor: (programText) ->
    @commands = CommandList.parse(programText)
    @session = new Session()
    @peripherals = new TestPeripherals(@session)
