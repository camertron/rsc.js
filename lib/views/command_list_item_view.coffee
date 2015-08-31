class CommandListItemView
  @template = '''
    <div class='rsc-command-list-item'>
      <div class='rsc-line-number rsc-computer-font'></div>
      <input type='text' maxlength='7' class='rsc-input-field rsc-computer-font' />
      <div class='rsc-indicator'></div>
    </div>
  '''

  constructor: (command) ->
    @elem = $(CommandListItemView.template)
    @lineNumber = $('.rsc-line-number', @elem)
    @indicator = $('.rsc-indicator', @elem)
    @inputField = $("input[type='text']", @elem)
    @command = command

    @inputField.blur => @validate()

    @inputField.keydown (e) =>
      if @indicatesNextFieldHighlight(e)
        Events.fireIfDefined(@, 'onHighlightNextFieldCallback')
      else if @indicatesPreviousFieldHighlight(e)
        Events.fireIfDefined(@, 'onHighlightPreviousFieldCallback')
      else if @indicatesInsertRow(e)
        Events.fireIfDefined(@, 'onInsertRowCallback')
      else if @indicatesDeleteRow(e)
        e.preventDefault()
        Events.fireIfDefined(@, 'onDeleteRowCallback')

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
    else if Utils.isNumeric(@inputField.val())
      @command = parseFloat(@inputField.val())
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

  onInsertRow: (callback) ->
    @onInsertRowCallback = callback

  onDeleteRow: (callback) ->
    @onDeleteRowCallback = callback

  onValidateFinished: (callback) ->
    @onValidateFinishedCallback = callback

  indicatesNextFieldHighlight: (e) ->
    e.keyCode == 40  # down arrow

  indicatesPreviousFieldHighlight: (e) ->
    e.keyCode == 38  # up arrow

  indicatesInsertRow: (e) ->
    e.keyCode == 13  # enter key

  indicatesDeleteRow: (e) ->
    range = @inputField.textrange()
    e.keyCode == 8 && range.start == 0 && range.length == 0 # && @inputField.val() == ''

  setValue: (val) ->
    @inputField.val(val)
    @validate()

  hasCommand: ->
    @command?.constructor == Command
