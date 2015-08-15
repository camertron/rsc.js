class Utils
  @isNumeric = (num) ->
    !isNaN(parseFloat(num)) && isFinite(num)
