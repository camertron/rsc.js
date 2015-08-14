class CommandListView
  @template = '''
    <div class='rsc-command-list'>
      <h4 class='rsc-computer-font'>Command List</h4>
      <div class='commands'></div>
      <div class='rsc-error-list'></div>
    </div>
  '''

  @columnTemplate = '''
    <div class='rsc-command-list-column'></div>
  '''

  @errorMessageTemplate = '''
    <p>
      <u><strong>Line %{lineNumber}</strong></u>:
      <span class='rsc-computer-font'>%{errorMessage}</span>
    </p>
  '''

  constructor: (@model, options = {}) ->
    @elem = $(CommandListView.template)
    @errorList = $('.rsc-error-list', @elem)
    @numColumns = options.numColumns || Rsc.defaultNumColumns
    @numRows = options.numRows || Rsc.defaultNumRows

    commandList = $('.commands', @elem)

    @columns = for col in [0...@numColumns]
      colElem = $(CommandListView.columnTemplate)

      rowElems = for row in [0...@numRows]
        item = @createListItemAt(col, row)
        item.lineNumber.text(@getLineNumber(col, row).toString())
        colElem.append(item.elem)
        item

      commandList.append(colElem)
      rowElems

  createListItemAt: (col, row) ->
    item = new CommandListItemView()

    item.onHighlightNextField =>
      @getField(@nextColumn(col, row), @nextRow(col, row)).focus()

    item.onHighlightPreviousField =>
      @getField(@prevColumn(col, row), @prevRow(col, row)).focus()

    item.onValidateFinished =>
      @updateErrorList()

    item

  updateErrorList: ->
    @errorList.html('')

    @eachField (col, row, field) =>
      if field.command?
        for error in field.command.errors
          lineNumber = @getLineNumber(col, row)
          @errorList.append(
            CommandListView.errorMessageTemplate
              .replace('%{lineNumber}', lineNumber)
              .replace('%{errorMessage}', error)
          )

  prevColumn: (col, row) ->
    if row == 0
      if col > 0
        return col - 1

    col

  prevRow: (col, row) ->
    if row == 0
      if col > 0
        return @numRows - 1
    else
      return row - 1

    row

  nextColumn: (col, row) ->
    if row >= @numRows - 1
      if col < @numColumns - 1
        return col + 1

    col

  nextRow: (col, row) ->
    if row >= @numRows - 1
      if col < @numColumns - 1
        return 0
    else
      return row + 1

    row

  getLineNumber: (col, row) ->
    @getFieldIndex(col, row) + 1

  getFieldIndex: (col, row) ->
    (col * @numRows) + row

  eachField: (callback) ->
    for colObj, col in @columns
      for rowObj, row in colObj
        callback(col, row, @getField(col, row))

  getCommands: ->
    commands = []
    @eachField (col, row, field) -> commands.push(field.command)
    commands

  getField: (col, row) ->
    @columns[col][row]
