class KeyboardView
  @template = '''
    <div class='rsc-peripheral-keyboard'>
      <div class='rsc-keyboard-image'></div>
      <input type='text' class='rsc-input-field rsc-computer-font' />
      <div class='rsc-computer-font rsc-error' style='display: none'>
        × Input must be a number!
      </div>
    </div>
  '''

  constructor: ->
    @elem = $(KeyboardView.template)
    @inputField = $("input[type='text']", @elem)
    @errorMessage = $('.rsc-error', @elem)

    @inputField.keydown (e) =>
      if e.keyCode == 13
        if Utils.isNumeric(@inputField.val())
          Events.fireIfDefined(@, 'onInputReceivedCallback', parseFloat(@inputField.val()))
          @errorMessage.hide()
        else
          @errorMessage.show()

  onInputReceived: (callback) ->
    @onInputReceivedCallback = callback

  reset: ->
    @errorMessage.hide()
    @inputField.val('')
