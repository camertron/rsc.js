class ControlsView
  @template = '''
    <div class='rsc-controls'>
      <h4 class='rsc-computer-font'>Controls</h4>
      <input type='button' value='Run Program' class='click-me rsc-button' />
      <input type='button' value='Clear Mem' class='rsc-button' />
    </div>
  '''

  constructor: ->
    @elem = $(ControlsView.template)
