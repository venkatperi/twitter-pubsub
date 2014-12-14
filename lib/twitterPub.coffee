conf = require './conf'
Twit = require 'twit'
redis = require 'node-redis'

T = new Twit( conf.get "twitter:auth" )

class Publisher
  constructor : ( opts = {} ) ->
    @redisPort = opts.redisport
    @redisIp = opts.redisip
    @endpoint = opts.endpoint
    @timeout = opts.timeout or 1000
    @start()

  start : =>
    @createRedisClient()
    @createTwitterStream()

  stop : =>
    @redisClient.quit()
    @twitterStream.stop()


  createRedisClient : =>
    console.log "Connecting to redis #{@redisIp}:#{@redisPort}"
    @redisClient = redis.createClient @redisPort, @redisIp
    @redisClient.on "error", ( err ) ->
      console.log "Redis error " + err

  createTwitterStream : =>
    console.log "Connecting to twitter (#{@endpoint})"
    @twitterStream = T.stream @endpoint

    @twitterStream.on 'tweet', ( tweet ) =>
      @redisClient.publish "tweet", JSON.stringify( tweet )

    @twitterStream.on 'error', ( err ) =>
      console.log err.message
      console.log "Retrying in #{@timeout} ms"
      setTimeout @createTwitterStream, @timeout
      @timeout += 500

publisher = null
createPublisher = ( opts ) -> publisher = new Publisher opts
module.exports = createPublisher
