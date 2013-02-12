Ember.MultiItemViewCollectionView =
Ember.CollectionView.extend Ember.StyleBindingsMixin,
  itemViewClassField: null
  styleBindings: 'width'
  createChildView: (view, attrs) ->
    itemViewClassField = @get 'itemViewClassField'
    itemViewClass = attrs.content.get(itemViewClassField)
    if typeof itemViewClass is 'string'
      itemViewClass = Ember.get Ember.lookup, itemViewClass
    @_super(itemViewClass, attrs)

Ember.MouseWheelHandlerMixin = Ember.Mixin.create
  onMouseWheel: Ember.K
  didInsertElement: ->
    @_super()
    @$().bind 'mousewheel', (event, delta, deltaX, deltaY) =>
      Ember.run this, @onMouseWheel, event, delta, deltaX, deltaY
  willDestroy: ->
    @$()?.unbind 'mousewheel'
    @_super()

Ember.ScrollHandlerMixin = Ember.Mixin.create
  onScroll: Ember.K
  didInsertElement: ->
    @_super()
    @$().bind 'scroll', (event) =>
      Ember.run this, @onScroll, event
  willDestroy: ->
    @$()?.unbind 'scroll'
    @_super()
