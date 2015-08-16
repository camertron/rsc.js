class Button
  @template = '''
    <input type='button' class='rsc-button' />
  '''

  constructor: (text, options = {}) ->
    @elem = $(Button.template)
    @elem.val(text)

    if options.classes?
      @elem.addClass(options.classes.join(' '))

    if options.enabled? && !options.enabled
      @elem.prop('disabled', true)

    @elem.click =>
      Events.fireIfDefined(@, 'onClickCallback')

  onClick: (callback) ->
    @onClickCallback = callback

  enable: ->
    @elem.prop('disabled', false)

  disable: ->
    @elem.prop('disabled', true)
