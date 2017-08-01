indentation = ->
  return " ".repeat(flContexts.length * 2)

# variation of base64, generates valid IDs from
# an arbitrary string. This should be made
# tighter, as the encoding is not unique
# unfortunately, we need 64 chars but there aren't
# 64 chars that are valid for IDs so the $ is used
# twice, so we could have collisions.
ValidID = 
  _keyStr: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789$$_'
  fromString: (input) ->
    output = ''
    i = 0
    input = ValidID._utf8_encode(input)
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
      output = output + @_keyStr.charAt(enc1) + @_keyStr.charAt(enc2) + @_keyStr.charAt(enc3) + @_keyStr.charAt(enc4)
    return "$" + output
  _utf8_encode: (string) ->
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
