AtomBeanBuilderView = require './atom-bean-builder-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomBeanBuilder =
  atomBeanBuilderView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    console.log 'SUP BITCHES'
    @atomBeanBuilderView = new AtomBeanBuilderView(state.atomBeanBuilderViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomBeanBuilderView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-bean-builder:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomBeanBuilderView.destroy()

  serialize: ->
    atomBeanBuilderViewState: @atomBeanBuilderView.serialize()

  toggle: ->
    console.log 'AtomBeanBuilder was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
      console.log 'Hiding window'
    else
      console.log 'Showing window'
      @modalPanel.show()
