osxNotifier = require './osxNotifier'

module.exports = (tweet) ->
  msg = JSON.parse tweet
  text = msg.text
  text = '\\' + text if text[ 0 ] in [ '"', '[', '(', "'" ]
  options =
    message : text
    title : msg.user.name
    appIcon : msg.user.profile_image_url

  options.open = msg.entities.urls[ 0 ].url if msg.entities.urls?.length
  options.contentImage = msg.entities.media[ 0 ].media_url if msg.entities.media?.length

  osxNotifier.info options


