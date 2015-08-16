class MonitorView
  @template = '''
    <div class='rsc-peripheral-monitor'>
      <div class='rsc-monitor-image'>
        <div class='rsc-monitor-output-field rsc-computer-font'></div>
      </div>
    </div>
  '''

  constructor: ->
    @elem = $(MonitorView.template)
    @outputField = $('.rsc-monitor-output-field', @elem)

  displayValue: (value) ->
    if Utils.isNumeric(value)
      @outputField.text(value.toFixed(1))

  reset: ->
    @outputField.text('')
