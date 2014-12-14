redis = require 'node-redis'

class Subscriber
  constructor : ( opts = {} ) ->
    @redisPort = opts.redisport
    @redisIp = opts.redisip
    @timeout = opts.timeout or 1000
    @notifier = opts.notifier or "console"
    console.log "Using notifier: #{@notifier}"
    @start()

  start : =>
    @createRedisClient()

  stop : =>
    @redisClient.quit()

  createRedisClient : =>
    console.log "Connecting to redis #{@redisIp}:#{@redisPort}"
    @redisClient = redis.createClient @redisPort, @redisIp

    @redisClient.on "error", ( err ) ->
      console.log "Redis error " + err

    @redisClient.on "message", ( channel, message ) =>
      return @onTweet( message ) if channel is "tweet"

    @redisClient.subscribe "tweet"

  onTweet : ( tweet ) =>
    require( "./notifier/#{@notifier}" )( tweet )

subscriber = null
createSubscriber = ( opts ) -> subscriber = new Subscriber opts
module.exports = createSubscriber