_ = require 'underscore'
Natural = require 'natural'

abbreviations =
  "ATH" : "all time high"
  "YTD" : "year to date"
  "LOD" : "low of the day"
  "USDJPY" : "symbol U S D J P Y"
  "AI" : "artificial intelligence"
  "SPRDS" : "spreads"
  "GOVT" : "government"
  "incl" : "including"

tok = new Natural.WordPunctTokenizer()

abbr = ( text ) ->
  tokens = text.split " "
  result = []
  for t in tokens
    v = abbreviations[ t.toUpperCase() ]
    result.push v or t

  text = result.join " "

symbol = ( text ) ->
  text.replace /\$[a-z_0-9]+/gi, ( x ) ->
    return x unless _.isNaN Number( x.substr( 1 ) )
    "symbol " + x.substr( 1 ).split( "" ).join( " " )

mention = (text) ->
  text = text.replace /@[a-z_0-9]+/gi, " "

preprocess = ( text, tweet ) ->
  console.log tweet
  text = text.replace /RT /gi, "re tweet"
  text = symbol text
  text = mention text
  text = abbr text

  console.log text
  text

module.exports = preprocess
