class CommandListItemView
  @template = '''
    <div class='rsc-command-list-item'>
      <div class='rsc-line-number rsc-computer-font'></div>
      <input type='text' maxlength='7' class='rsc-computer-font' />
      <div class='rsc-syntax-error'>×</div>
    </div>
  '''

  constructor: (model) ->
    @elem = $(CommandListItemView.template)
    @lineNumber = $('.rsc-line-number', @elem)
    @syntaxErrorField = $('.rsc-syntax-error', @elem)
    @inputField = $("input[type='text']", @elem)
    @command = model

    @inputField.blur => @validate()

    @inputField.keydown (e) =>
      if @indicatesNextFieldHighlight(e)
        @fireIfDefined('onHighlightNextFieldCallback')
      else if @indicatesPreviousFieldHighlight(e)
        @fireIfDefined('onHighlightPreviousFieldCallback')

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

    visibility = if valid then 'hidden' else 'visible'
    @syntaxErrorField.css('visibility', visibility)

    if valid
      @elem.removeClass('error')
    else
      @elem.addClass('error')

    @fireIfDefined('onValidateFinishedCallback')

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

  fireIfDefined: (callbackName) ->
    @[callbackName]() if @[callbackName]?
