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
          @reset()
          @errorMessage.hide()
        else
          @errorMessage.show()

  onInputReceived: (callback) ->
    @onInputReceivedCallback = callback

  enable: ->
    @inputField.prop('disabled', false)

  disable: ->
    @inputField.prop('disabled', true)

  focus: ->
    @inputField.focus()

  reset: ->
    @errorMessage.hide()
    @hideIndicator()
    @inputField.val('')

  showIndicator: (animate = true) ->
    if animate
      cycles = 0

      id = setInterval((=>
        if @elem.hasClass('info')
          @elem.removeClass('info')
        else
          @elem.addClass('info')

        cycles += 1

        if cycles == 5
          clearInterval(id)
          @elem.addClass('info')
      ), 100)
    else
      @elem.addClass('info')

  hideIndicator: ->
    @elem.removeClass('info')
