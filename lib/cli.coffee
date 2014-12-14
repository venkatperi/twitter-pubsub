conf = require "./conf"
parser = require( 'nomnom' )
publisher = require './twitterPub'
subscriber = require './twitterSub'

parser.script "tpubsub"

parser.command "publish"
.option "endpoint",
  default : conf.get "twitter:endpoint"
  help : "twitter streaming endpoint"

.option "redisport",
  default : conf.get "redis:port"
  help : "Redis port"

.option "redisip",
  default : conf.get "redis:ip"
  help : "Redis IP"

.help "Start in 'publish' mode"
.callback publisher

parser.command "subscribe"
.option "redisport",
  default : conf.get "redis:port"
  help : "Redis port"

.option "redisip",
  default : conf.get "redis:ip"
  help : "Redis IP"

.option "notify",
  default : "console"
  help : "Notifier to use (console | osx)"

.help "Start in 'subscribe' mode"
.callback subscriber

parser.parse()

