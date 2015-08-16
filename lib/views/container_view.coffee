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

    @commandList = new CommandListView(options)
    @commandListContainer.append(@commandList.elem)

    @peripherals = new PeripheralsView()
    @peripheralsContainer.append(@peripherals.elem)

    @controls = new ControlsView()
    @controlsContainer.append(@controls.elem)

  reset: ->
    @commandList.reset()
    @controls.reset()
    @peripherals.reset()
