osxNotifier = require './osxNotifier'
_ = require 'underscore'

module.exports = ( tweet ) ->
  msg = JSON.parse tweet
  text = _.unescape msg.text
  for url in msg.entities.urls
    console.log url
    text = text.replace url.url, " "
    text = text.replace url.display_url, " "
    text = text.replace url.expanded_url, " "
  text = text.replace /\s{2,}/g, ' '
  text = text[ 0 ].toUpperCase() + text.substr( 1 ).toLowerCase()
  text = '\\' + text if text[ 0 ] in [ '"', '[', '(', "'" ]
  console.log text
  options =
    message : text
    title : msg.user.name
    appIcon : msg.user.profile_image_url

  options.open = msg.entities.urls[ 0 ].url if msg.entities.urls?.length
  options.contentImage = msg.entities.media[ 0 ].media_url if msg.entities.media?.length

  osxNotifier.info options


