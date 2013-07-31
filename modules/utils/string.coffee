exports = module.exports =
  capitalize: (str) ->
    str.charAt(0).toUpperCase() + str.slice(1)
  firstCap: (str) ->
    str.charAt(0).toUpperCase() + str.toLowerCase().slice(1)