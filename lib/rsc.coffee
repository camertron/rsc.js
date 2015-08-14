class Rsc
  @defaultNumColumns = 3
  @defaultNumRows = 15

  constructor: (selector, options = {}) ->
    @container = new ContainerView(options)
    $(selector).replaceWith(@container.elem)

root = exports ? @
root.Rsc = Rsc
