module.exports =
class BeanCloudCompilerClient
  constructor: () ->
    @url = ''

  compile: (sketchPath) ->
    console.log 'Compiling sketch %s', sketchPath
