class AccumulatorView
  @template = '''
    <div class='rsc-peripheral-accumulator rsc-computer-font'>
      Accumulator: <span class='rsc-accumulator-value'></span>
    </div>
  '''

  constructor: ->
    @elem = $(AccumulatorView.template)
    @valueField = $('.rsc-accumulator-value', @elem)

  setValue: (val) ->
    @valueField.text(val.toFixed(1))

  getValue: ->
    if Utils.isNumeric(@valueField.text())
      parseFloat(@valueField.text())
