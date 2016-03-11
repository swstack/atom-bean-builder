fs = require('fs')
request = require('request')
crypto = require('crypto')
utf8 = require('utf8')

module.exports =

class BeanCloudCompilerClient
  constructor: (config) ->
    @config = config

  makeRequest: (data) ->
    request.post(
      "#{@config.BCC_HOST}/1.0/compile",
      {form: data},
      (err, resp, body)=>
        console.log "GOT RESPONSE"
        console.log err
        console.log resp
        console.log body
    )

  compile: (sketchPath) ->
    console.log 'Compiling sketch %s', sketchPath

    reqInner =
      api_key: @config.BCC_KEY
      app_version: '0.0.1'
      code: fs.readFileSync(sketchPath, 'utf8')
      opt_out: 0
      os_version: 'OS X'
      request_timestamp: Math.floor(Date.now() / 1000)
      unique_id: ''

    jsonInner = JSON.stringify(reqInner)

    hmac = crypto.createHmac('sha512', @config.BCC_SECRET)
    hmac.update(jsonInner)
    hash = hmac.digest('hex')

    reqOuter =
      data: jsonInner
      hash: hash

    @makeRequest(reqOuter)
