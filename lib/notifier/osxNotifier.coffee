Q = require 'q'
exec = require( "child_process" ).execFile
binary = "/usr/bin/terminal-notifier"
preTTS = require '../util/preTTS'

execute = ( file, args ) ->
  defer = Q.defer()
  exec file, args, ( error, stdout ) ->
    stdout = (if stdout then stdout.trim().split( "\n" ) else null)
    if error
      error.error = stdout or "invalid type."
      defer.reject error
    else
      defer.resolve stdout

list = ( rows ) ->
  notifications = []
  headers = rows.shift().toLowerCase().replace( " ", "_" ).replace( "id", "_id" ).split( "\t" )
  rows.forEach ( row ) ->
    cols = row.split( "\t" )
    result = {}
    cols.forEach ( col, i ) -> result[ headers[ i ] ] = (if col is "(null)" then null else col)
    notifications.push result

  notifications : notifications

att_tts = (text, opts) ->
  child = execute "/usr/bin/att-tts"
  child.stdin.write preTTS( args.message, tweet )
  child.stdin.end()

module.exports =
  info : ( args, tweet, cb ) ->
    type = "info"
    #  console.info.apply console, ["Notifying >"].concat([type], args)
    #  file = binary.replace("{type}", type)
    file = binary
    method_args = []
    Object.keys( args ).forEach ( arg ) ->
      method_args.push "-" + arg
      method_args.push args[ arg ]

    execute "/usr/bin/say", [ "-v", "samantha", preTTS( args.message, tweet ) ]
    execute file, method_args, cb
