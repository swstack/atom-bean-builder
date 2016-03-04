fs = require('fs')

###
{
    'data':
      {
        'api_key': key,
        'app_version': '0.0.1',
        'code': sketch_data,
        'opt_out': 0,
        'os_version': os_version,
        'request_timestamp': int(time()),  # Unix
        'unique_id': 'SOME_UNIQUE_TEST_ID'
      }

    'hash':
      hmac.new(secret, inner_json.encode('utf-8'), sha512.hexdigest()
}
###

module.exports =
class BeanCloudCompilerClient
  constructor: () ->
    @url = ''

  compile: (sketchPath) ->
    console.log 'Compiling sketch %s', sketchPath
    # buf = new buffer.Buffer()
    # sketch = fs.openSync(filepath, 'r')
    sketchRaw = fs.readFileSync(sketchPath)

    reqInner =
      api_key: ''
      app_version: ''
      code: sketchRaw
      opt_out: 0
      os_version: 'OS X'
      request_timestamp: ''
      unique_id: ''

    reqOuter =
      data: reqInner
      hash: ''
