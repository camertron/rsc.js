class CommandListView
  @template = '''
    <div class='rsc-command-list'>
      <h4 class='rsc-computer-font'>Command List</h4>
      <div class='rsc-commands-container'></div>
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

  constructor: (options = {}) ->
    options.commands = {} unless options.commands?
    @elem = $(CommandListView.template)
    @errorList = $('.rsc-error-list', @elem)
    @numColumns = options.numColumns || Rsc.defaultNumColumns
    @numRows = options.numRows || Rsc.defaultNumRows
    @columns = []

    commandList = $('.rsc-commands-container', @elem)

    @columns = for col in [0...@numColumns]
      colElem = $(CommandListView.columnTemplate)

      rowElems = for row in [0...@numRows]
        item = @createListItemAt(col, row)
        item.lineNumber.text(@getLineNumber(col, row).toString())
        initialValue = options.commands[@getFieldIndex(col, row)]
        item.setValue(initialValue) if initialValue?
        colElem.append(item.elem)
        item

      commandList.append(colElem)
      rowElems

  toBase64: ->
    values = {}

    @eachField (col, row, field) =>
      if field.hasCommand()
        idx = @getFieldIndex(col, row)
        values[idx] = field.command.toString()

    btoa(JSON.stringify(values))

  createListItemAt: (col, row) ->
    item = new CommandListItemView()

    item.onHighlightNextField =>
      @getField(@nextColumn(col, row), @nextRow(col, row)).focus()

    item.onHighlightPreviousField =>
      @getField(@prevColumn(col, row), @prevRow(col, row)).focus()

    item.onInsertRow => @insertRowAt(col, row)
    item.onDeleteRow => @deleteRowAt(col, row)

    item.onValidateFinished =>
      @updateErrorList()
      Events.fireIfDefined(@, 'onItemValidationFinishedCallback', item)

    item

  insertRowAt: (col, row) ->
    if @canInsert()
      startIdx = @getFieldIndex(col, row)
      endIdx = @getFieldCount() - 1

      for i in [endIdx...startIdx]
        cur = @getFieldAtIndex(i)
        prev = @getFieldAtIndex(i - 1)
        cur.setValue(prev.inputField.val())

      if startIdx < @getFieldCount() - 1
        inserted = @getFieldAtIndex(startIdx + 1)
        inserted.command = undefined
        inserted.setValue('')
        inserted.focus()

  deleteRowAt: (col, row) ->
    startIdx = @getFieldIndex(col, row) - 1
    return unless startIdx >= 0
    justMoveCursor = false

    # if the current field is blank, don't replace the one
    # before it - just move the cursor
    if @getFieldAtIndex(startIdx + 1).inputField.val() == ''
      justMoveCursor = true
      startIdx += 1

    endIdx = @getFieldCount() - 1

    for i in [startIdx...endIdx]
      cur = @getFieldAtIndex(i)
      next = @getFieldAtIndex(i + 1)
      cur.setValue(next.inputField.val())

    focusIdx = if justMoveCursor then startIdx - 1 else startIdx
    removed = @getFieldAtIndex(focusIdx)
    removed.focus()

  canInsert: ->
    # make sure there's a blank line at the end
    !@getField(@numColumns - 1, @numRows - 1).hasCommand()

  onItemValidationFinished: (callback) ->
    @onItemValidationFinishedCallback = callback

  getErrors: ->
    errors = []

    @eachField (col, row, field) =>
      if field.hasCommand()
        errors += field.command.errors

    errors

  updateErrorList: ->
    @errorList.html('')

    @eachField (col, row, field) =>
      if field.hasCommand()
        for error in field.command.errors
          lineNumber = @getLineNumber(col, row)
          @errorList.append(
            CommandListView.errorMessageTemplate
              .replace('%{lineNumber}', lineNumber)
              .replace('%{errorMessage}', error)
          )

  indicateExecutionForLine: (line) ->
    @eachField (col, row, field) =>
      if @getFieldIndex(col, row) == line
        field.showExecutionIndicator()
      else
        field.hideIndicator()

  hideExecutionIndicator: ->
    @eachField (col, row, field) =>
      field.hideIndicator()

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

  getFieldAtIndex: (index) ->
    @getField(@getColAtIndex(index), @getRowAtIndex(index))

  getColAtIndex: (index) ->
    Math.floor(index / @numRows)

  getRowAtIndex: (index) ->
    index % @numRows

  getFieldCount: ->
    @numRows * @numColumns

  setFieldValueAtIndex: (index, value) ->
    @getFieldAtIndex(index).inputField.val(value.toFixed(1))

  clearFieldValueAtIndex: (index) ->
    @getFieldAtIndex(index).inputField.val('')

  reset: ->
    @hideExecutionIndicator()
    @enable()

  clear: ->
    @eachField (col, row, field) -> field.clear()
    @updateErrorList()

  disable: ->
    @eachField (col, row, field) -> field.disable()

  enable: ->
    @eachField (col, row, field) -> field.enable()
