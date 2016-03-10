path = require 'path'
fs = require 'fs'
BeanCloudCompilerClient = require './bcc-client'
PostCompile = require './post-compile'
AtomBeanBuilderView = require './atom-bean-builder-view'
{CompositeDisposable} = require 'atom'


module.exports = AtomBeanBuilder =
  atomBeanBuilderView: null
  subscriptions: null

  activate: (state) ->
    @atomBeanBuilderView = new AtomBeanBuilderView(state.atomBeanBuilderViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-bean-builder:build': => @build()

    # Custom dependencies
    config = fs.readFileSync(path.join __dirname, 'config', 'app.json')
    @bccClient = new BeanCloudCompilerClient(JSON.parse config)

  deactivate: ->
    @subscriptions.dispose()
    @atomBeanBuilderView.destroy()

  serialize: ->
    atomBeanBuilderViewState: @atomBeanBuilderView.serialize()

  build: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    @bccClient.compile file.path, (err, rawHex) =>
      if err
        console.log "BCC Error: #{err}"
      else
        console.log "Sketch compiled successfully"
        pathObj = path.parse(file.path)
        # hexBuffer = new Buffer(rawHex, 'utf8')
        PostCompile.execute pathObj, rawHex
