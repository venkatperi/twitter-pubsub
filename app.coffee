require './lib/util/property'

process.on "uncaughtException", ( err ) ->
  console.log err.message

require './lib/cli'
