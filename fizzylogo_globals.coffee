repeatFunctionContinuation = null

outerMostContext = null

DEBUG_STRINGIFICATION_CHECKS = true

if DEBUG_STRINGIFICATION_CHECKS
  stringsTable_TO_CHECK_CONVERTIONS = {}

indentation = ->
  #return " ".repeat(flContexts.length * 2)
  return ""

# to disambiguate between when we are operating
# on JS arrays from when we are operating
# on fizzylogo lists.
Array::jsArrayPush = (element) ->
  @push element

# variation of base64, generates valid IDs from
# an arbitrary string. Little known fact, javascript
# IDs can start with and have some pretty wild chars
# see https://stackoverflow.com/questions/1661197/what-characters-are-valid-for-javascript-variable-names
keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789Γಠ_'
ValidIDfromString = (input) ->

    #console.log "ValidIDfromString encoding: " + input

    if /^([A-Z_][0-9A-Z_$]*)$/gi.test input
      #console.log "ValidIDfromString encoded as: " + input
      return input

    utf8_encode = (string) ->
      string = string.replace(/\r\n/g, '\n')
      utftext = ''
      n = 0
      while n < string.length
        c = string.charCodeAt(n)
        if c < 128
          utftext += String.fromCharCode(c)
        else if c > 127 and c < 2048
          utftext += String.fromCharCode(c >> 6 | 192)
          utftext += String.fromCharCode(c & 63 | 128)
        else
          utftext += String.fromCharCode(c >> 12 | 224)
          utftext += String.fromCharCode(c >> 6 & 63 | 128)
          utftext += String.fromCharCode(c & 63 | 128)
        n++
      utftext


    output = ''
    i = 0
    input = utf8_encode(input)
    while i < input.length
      chr1 = input.charCodeAt(i++)
      chr2 = input.charCodeAt(i++)
      chr3 = input.charCodeAt(i++)
      enc1 = chr1 >> 2
      enc2 = (chr1 & 3) << 4 | chr2 >> 4
      enc3 = (chr2 & 15) << 2 | chr3 >> 6
      enc4 = chr3 & 63
      if isNaN(chr2)
        enc3 = enc4 = 64
      else if isNaN(chr3)
        enc4 = 64
      output = output + keyStr.charAt(enc1) + keyStr.charAt(enc2) + keyStr.charAt(enc3) + keyStr.charAt(enc4)
    #console.log "ValidIDfromString encoded as: " + "$" + output
    return "$" + output

StringFromValidID = (input) ->

    if /^([A-Z_][0-9A-Z_$]*)$/gi.test input
      return input


    utf8_decode = (string) ->
      output = ''
      i = 0
      charCode = 0
      while i < string.length
        charCode = string.charCodeAt(i)
        if charCode < 128
          output += String.fromCharCode(charCode)
          i++
        else if charCode > 191 and charCode < 224
          output += String.fromCharCode((charCode & 31) << 6 | string.charCodeAt(i + 1) & 63)
          i += 2
        else
          output += String.fromCharCode((charCode & 15) << 12 | (string.charCodeAt(i + 1) & 63) << 6 | string.charCodeAt(i + 2) & 63)
          i += 3
      output

    input = input.replace(/[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789Γಠ_]/g, '')
    input = input.replace(/^\$/, '')
    #console.log "StringFromValidID decoding: " + input
    output = ''
    i = 0
    while i < input.length
      d = keyStr.indexOf(input.charAt(i++))
      e = keyStr.indexOf(input.charAt(i++))
      f = keyStr.indexOf(input.charAt(i++))
      g = keyStr.indexOf(input.charAt(i++))
      a = d << 2 | e >> 4
      b = (e & 15) << 4 | f >> 2
      c = (f & 3) << 6 | g
      output += String.fromCharCode(a)
      if f != 64
        output += String.fromCharCode(b)
      if g != 64
        output += String.fromCharCode(c)
    return utf8_decode output


sortFirstArrayAccordingToSecond = (targetData, refData) ->
  # create an array of indices [0, 1, ... targetData.length] and
  # sort those specularly to refData

  indices = [0...targetData.length]
  # Sort array of indices according to the reference data.
  indices.sort (indexA, indexB) ->
    if refData[indexA] < refData[indexB]
      #console.log "refData[indexA] < refData[indexB] " + refData[indexA]  + " " + refData[indexB]
      return -1
    else if refData[indexA] > refData[indexB]
      #console.log "refData[indexA] > refData[indexB] " + refData[indexA]  + " " + refData[indexB]
      return 1
    #console.log "refData[indexA] = refData[indexB] " + refData[indexA]  + " " + refData[indexB]
    0
  # Map array of indices to corresponding values of the target array.
  return indices.map (index) -> targetData[index]


allClasses = []
