class Events
  @fireIfDefined = (obj, callbackName, args...) ->
    obj[callbackName].apply(@, args) if obj[callbackName]?
