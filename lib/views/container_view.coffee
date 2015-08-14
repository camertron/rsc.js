class ContainerView
  @template = '''
    <div class='rsc-container'>
      <input type='button' value='Interpret' class='click-me' />
    </div>
  '''

  constructor: (options = {}) ->
    @elem = $(ContainerView.template)
    @commandList = new CommandListView()
    @elem.append(@commandList.elem)

    $('.click-me', @elem).click =>
      interpreter = new Interpreter(options)
      res = interpreter.interpret(@commandList.getCommands())
