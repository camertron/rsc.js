class ContainerView
  @template = '''
    <div class='rsc-container'>
      <div class='rsc-command-list-container'></div>
      <div class='rsc-peripherals-container'></div>
      <div class='rsc-controls-container'></div>
    </div>
  '''

  constructor: (options = {}) ->
    @elem = $(ContainerView.template)
    @commandListContainer = $('.rsc-command-list-container', @elem)
    @peripheralsContainer = $('.rsc-peripherals-container', @elem)
    @controlsContainer = $('.rsc-controls-container', @elem)

    @commandList = new CommandListView()
    @commandListContainer.append(@commandList.elem)

    @peripherals = new PeripheralsView()
    @peripheralsContainer.append(@peripherals.elem)
    @peripherals.keyboard.onInputReceived (val) ->

    @controls = new ControlsView()
    @controlsContainer.append(@controls.elem)

    $('.click-me', @elem).click =>
      interpreter = new Interpreter(@peripherals)
      res = interpreter.interpret(@commandList.getCommands())
