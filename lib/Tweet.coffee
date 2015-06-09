_ = require 'underscore'
S = require 'string'
_prop = require './util/property'

rmProto = ( url ) ->
  url = S( url )
  for proto in [ "http://", "https://", "ftp://", "http:/" ]
    url = url.replaceAll proto, ""
  url.toString()

rmAnyUrl = ( text ) ->
  text.replace /\w+:\/\/[^ "]+/gi, ""

class Tweet
  constructor : ( tweet, @opts = {} ) ->
    tweet = JSON.parse( tweet ) if typeof tweet is "string"
    @[ k ] = v for k, v of tweet

    clone : ( obj ) =>
      if not obj? or typeof obj isnt 'object'
        return obj

      if obj instanceof Date
        return new Date( obj.getTime() )

      if obj instanceof RegExp
        flags = ''
        flags += 'g' if obj.global?
        flags += 'i' if obj.ignoreCase?
        flags += 'm' if obj.multiline?
        flags += 'y' if obj.sticky?
        return new RegExp( obj.source, flags )

      newInstance = new obj.constructor()

      for key of obj
        newInstance[ key ] = clone obj[ key ]

      return newInstance

  @property 'isRetweet', get : -> @original.retweeted_status?

  @property 'text', get : -> @original.retweeted_status?.text or @original.text

  @property 'cleanText',
    get : ->
      t = rmAnyUrl @text
      t = t.replace /\s{2,}/g, ' '
      t = _.unescape t
      t = '\\' + t if t[ 0 ] in [ '"', '[', '(', "'" ] and @opts.osx
      t


module.exports = Tweet