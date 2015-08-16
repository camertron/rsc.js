class PeripheralsView
  @template = '''
    <div class='rsc-peripherals'>
      <h4 class='rsc-computer-font'>Peripherals</h4>
    </div>
  '''

  constructor: ->
    @elem = $(PeripheralsView.template)

    @accumulator = new AccumulatorView()
    @elem.append(@accumulator.elem)

    @monitor = new MonitorView()
    @elem.append(@monitor.elem)

    @keyboard = new KeyboardView()
    @elem.append(@keyboard.elem)

  reset: ->
    @monitor.reset()
    @keyboard.reset()
