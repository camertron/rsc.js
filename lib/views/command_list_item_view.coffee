class CommandListItemView
  @template = '''
    <div class='rsc-command-list-item'>
      <div class='rsc-line-number rsc-computer-font'></div>
      <input type='text' maxlength='7' class='rsc-input-field rsc-computer-font' />
      <div class='rsc-indicator'></div>
    </div>
  '''

  constructor: (model) ->
    @elem = $(CommandListItemView.template)
    @lineNumber = $('.rsc-line-number', @elem)
    @indicator = $('.rsc-indicator', @elem)
    @inputField = $("input[type='text']", @elem)
    @command = model

    @inputField.blur => @validate()

    @inputField.keydown (e) =>
      if @indicatesNextFieldHighlight(e)
        Events.fireIfDefined(@, 'onHighlightNextFieldCallback')
      else if @indicatesPreviousFieldHighlight(e)
        Events.fireIfDefined(@, 'onHighlightPreviousFieldCallback')

  showExecutionIndicator: ->
    @elem.addClass('info')

  showErrorIndicator: ->
    @elem.addClass('error')

  hideIndicator: ->
    @elem.removeClass('error info')

  disable: ->
    @inputField.prop('disabled', true)

  enable: ->
    @inputField.prop('disabled', false)

  clear: ->
    @inputField.val('')
    @command = null
    @hideIndicator()

  focus: ->
    @inputField.focus()
    @inputField.select()

  validate: ->
    val = @inputField.val()
    valid = true

    if val.trim() == ''
      @command = null
    else
      @command = Command.parse(@inputField.val())
      valid = @command.isValid()

    if valid
      @hideIndicator()
    else
      @showErrorIndicator()

    Events.fireIfDefined(@, 'onValidateFinishedCallback')

  onHighlightNextField: (callback) ->
    @onHighlightNextFieldCallback = callback

  onHighlightPreviousField: (callback) ->
    @onHighlightPreviousFieldCallback = callback

  onValidateFinished: (callback) ->
    @onValidateFinishedCallback = callback

  indicatesNextFieldHighlight: (e) ->
    # enter or down arrow
    e.keyCode == 13 || e.keyCode == 40

  indicatesPreviousFieldHighlight: (e) ->
    # up arrow
    e.keyCode == 38

  setValue: (val) ->
    @inputField.val(val)
    @validate()
