_ = require 'underscore'
S = require 'string'

rmProto = ( url ) ->
  url = S( url )
  for proto in [ "http://", "https://", "ftp://", "http:/" ]
    url = url.replaceAll proto, ""
  url.toString()

rmUrl = ( text, url ) ->
  url = rmProto( url ).toLowerCase()
  console.log url
  text.replace url, ""

rmAnyUrl = ( text ) ->
  text.replace /\w+:\/\/[^ "]+/gi, ""

cleanup = ( tweet, opts = {} ) ->
  tweet = JSON.parse tweet unless _.isObject( tweet )
  text = tweet.retweeted_status?.text or tweet.text
  #  text = tweet.text.toLowerCase()

  text = rmAnyUrl text
  #  for url in tweet.entities.urls
  #    for x in ["url", "display_url", "expanded_url"]
  #      text = rmUrl text, url[x]

  text = text.replace /\s{2,}/g, ' '
  text = _.unescape text
  text = '\\' + text if text[ 0 ] in [ '"', '[', '(', "'" ] and opts.osx
  text

module.exports = cleanup