cleanup = require '../util/cleanup'
osxNotifier = require './osxNotifier'
Tweet = require '../Tweet'

module.exports = ( tweet ) ->
  text = cleanup tweet, osx : true
  console.log text
  options =
    message : text
    title : tweet.user.name
    appIcon : tweet.user.profile_image_url

  options.open = tweet.entities.urls[ 0 ].url if tweet.entities.urls?.length
  options.contentImage = tweet.entities.media[ 0 ].media_url if tweet.entities.media?.length

  osxNotifier.info options, tweet


