class ControlsView
  @template = '''
    <div class='rsc-controls'>
      <h4 class='rsc-computer-font'>Controls</h4>
    </div>
  '''

  constructor: ->
    @elem = $(ControlsView.template)
    @runProgramButton = new Button('Run Program', classes: ['rsc-control-run'])
    @stepButton = new Button('Step', classes: ['rsc-control-step'], enabled: false)
    @stopButton = new Button('Stop', classes: ['rsc-control-step'], enabled: false)
    @clearMemButton = new Button('Clear Mem', classes: ['rsc-control-clear-mem'])

    @elem.append(@runProgramButton.elem)
    @elem.append(@stepButton.elem)
    @elem.append(@stopButton.elem)
    @elem.append(@clearMemButton.elem)

    @runProgramButton.onClick =>
      Events.fireIfDefined(@, 'onRunProgramButtonClickedCallback')

    @stepButton.onClick =>
      Events.fireIfDefined(@, 'onStepButtonClickedCallback')

    @stopButton.onClick =>
      Events.fireIfDefined(@, 'onStopButtonClickedCallback')

    @clearMemButton.onClick =>
      Events.fireIfDefined(@, 'onClearMemButtonClickedCallback')

  onRunProgramButtonClicked: (callback) ->
    @onRunProgramButtonClickedCallback = callback

  onStepButtonClicked: (callback) ->
    @onStepButtonClickedCallback = callback

  onStopButtonClicked: (callback) ->
    @onStopButtonClickedCallback = callback

  onClearMemButtonClicked: (callback) ->
    @onClearMemButtonClickedCallback = callback

  reset: ->
    @runProgramButton.enable()
    @clearMemButton.enable()
    @stepButton.disable()
    @stopButton.disable()
