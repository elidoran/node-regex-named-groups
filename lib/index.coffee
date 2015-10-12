# export a function which enhances the regex's exec() function
module.exports = (regex, names, options) ->
  unless regex? then throw new TypeError 'must provide regular expression and names'

  # `regex` must be the options  # TODO: test if it's *not* a regular expression
  if arguments.length is 1 then options = regex ; regex = null

  regex = regex ? options?.regex
  names = names ? options?.names
  preserve = options?.preserve ? false       # default to *not* preserving array

  superExec = RegExp.prototype.exec          # store original exec()
  regex.exec = (string) ->                   # create a new exec()
    array = superExec.call regex, string     # run original exec() on input
    if array?                                # was there a match?
      result = {}                            # where we'll store the named values
      for name,i in names                    # loop on our names to put into result
        result[name] = array[i + 1]          # use +1 to skip array[0] which has whole string
      if preserve then result.$array = array # optionally include array in result

    else result = null # re.exec() returns null on no match, not undefined

    return result

  return regex # and return the 'enhanced' version
