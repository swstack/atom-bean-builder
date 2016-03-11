proc = require 'child_process'
path = require 'path'
fs = require 'fs'
BeanCloudCompilerClient = require './bcc-client'
AtomBeanBuilderView = require './atom-bean-builder-view'
{CompositeDisposable} = require 'atom'

ARG_COMPILE_SCRIPT = path.join(__dirname, 'post_compile')
ARG_BOARD = 'atmega328p'
ARG_TOOLS = 'foo'
ARG_PATH = __dirname
ARG_FILE = 'test'
POST_COMPILE_COMMAND = "#{ARG_COMPILE_SCRIPT} -board=#{ARG_BOARD} -tools=#{ARG_TOOLS} -path=#{ARG_PATH} -file=#{ARG_FILE}"


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
    @bccClient.compile(file.path)
    # post_compile = proc.execSync(POST_COMPILE_COMMAND)
